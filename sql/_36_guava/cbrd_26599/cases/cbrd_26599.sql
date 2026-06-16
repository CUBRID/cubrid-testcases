/*
 * CBRD-26599: Transitive Join Term Generation - query plan verification.
 *
 * Verifies that qo_generate_transitive_join_terms() correctly generates
 * implicit join predicates for all missing node pairs within each equivalence
 * class, and that qo_sort_edges() produces a better join order as a result.
 *
 * Tables:
 *   tta : 1,000,000 rows (large)
 *   ttb : 1,000,000 rows (large)
 *   ttc :       100 rows (small - filtering anchor)
 *   ttd :       100 rows (small)
 *
 * All tables: ca = rownum (unique 1..N), cb = rownum.
 * Joins on ca are therefore unique-key joins; the result of any join chain
 * tta JOIN ttb JOIN ttc is at most 100 rows (bounded by ttc/ttd).
 *
 * Expected behavior in CBRD-26599:
 *   The transitive term tta.ca = ttc.ca is derived automatically from
 *   tta.ca = ttb.ca  AND  ttb.ca = ttc.ca.  This lets the optimizer join
 *   ttc (100 rows) before ttb (1M rows), reducing intermediate cardinality
 *   and improving cost significantly.
 */

-- ===================================================================
-- Setup
-- ===================================================================
evaluate '[SETUP] Create and populate large/small test tables';

drop table if exists tta;
drop table if exists ttb;
drop table if exists ttc;
drop table if exists ttd;

create table tta (ca int, cb int);
create table ttb (ca int, cb int);
create table ttc (ca int, cb int);
create table ttd (ca int, cb int);

insert into tta select rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 1000000;
insert into ttb select rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 1000000;
insert into ttc select rownum, rownum from db_class a, db_class b limit 100;
insert into ttd select rownum, rownum from db_class a, db_class b limit 100;

update statistics on tta, ttb, ttc, ttd;

/* ============================================================
 * Scenario 1: Basic 3-table hash join
 *
 * Transitive term tta.ca = ttc.ca is generated from:
 *   tta.ca = ttb.ca  AND  ttb.ca = ttc.ca
 *
 * Expected plan change:
 *   before     : ttb (1M) or tta (1M) joined before ttc (100)
 *   CBRD-26599 : ttc (100) joined first - intermediate card drops to 100
 * ============================================================ */
evaluate '[S1-1] Basic 3-table hash join - implicit JOIN syntax: ttc (100 rows) joined first via transitive term';
select /*+ recompile use_hash */ count(*)
from tta, ttb, ttc
where tta.ca = ttb.ca
  and ttb.ca = ttc.ca;

evaluate '[S1-2] Basic 3-table hash join - explicit JOIN syntax: same transitive optimization applies';
select /*+ recompile use_hash */ count(*)
from tta
  join ttb on tta.ca = ttb.ca
  join ttc on ttb.ca = ttc.ca;

/* ============================================================
 * Scenario 2: Explicit transitive term already in WHERE clause
 *
 * tta.ca = ttc.ca is provided explicitly alongside the two base terms.
 * CBRD-26599 must not generate a duplicate term; plan must remain correct.
 * ============================================================ */
evaluate '[S2] Explicit transitive term already in WHERE: no duplicate generated, plan remains correct';
select /*+ recompile use_hash */ count(*)
from tta, ttb, ttc
where tta.ca = ttb.ca
  and ttb.ca = ttc.ca
  and tta.ca = ttc.ca;

/* ============================================================
 * Scenario 3: Multi-hop transitive join (4-table chain)
 *
 * From tta.ca=ttb.ca, ttb.ca=ttc.ca, ttc.ca=ttd.ca, CBRD-26599 generates:
 *   tta.ca = ttc.ca,  tta.ca = ttd.ca,  ttb.ca = ttd.ca
 *
 * Expected plan change:
 *   ttc (100 rows) joined first to anchor cardinality,
 *   ttd joined last, but intermediate result is already 100 rows.
 * ============================================================ */
evaluate '[S3] 4-table chain: all transitive terms generated';
select /*+ recompile use_hash */ count(*)
from tta, ttb, ttc, ttd
where tta.ca = ttb.ca
  and ttb.ca = ttc.ca
  and ttc.ca = ttd.ca;

/* ============================================================
 * Scenario 4: Outer join boundary
 *
 * tta LEFT OUTER JOIN ttb ON tta.ca = ttb.ca
 *      INNER JOIN     ttc ON ttb.ca = ttc.ca
 *
 * tta.ca = ttc.ca must NOT be generated as a transitive term because
 * ttb rows may be NULL under the outer join, making the derivation unsound.
 * ============================================================ */
evaluate '[S4] Outer join boundary: transitive term must NOT cross LEFT OUTER JOIN (unsound derivation)';
select /*+ recompile use_hash */ count(*)
from tta
  left outer join ttb on tta.ca = ttb.ca
  inner join ttc on ttb.ca = ttc.ca;

/* ============================================================
 * Scenario 5: ORDERED hint via transitive term
 *
 * FROM order: tta, ttc, ttb  (tta -> ttc has no explicit join condition)
 *
 *   before     : no direct edge between tta and ttc -> ORDERED ignored (warning)
 *   CBRD-26599 : transitive term tta.ca = ttc.ca provides the missing edge
 *                -> ORDERED hint is applied, join proceeds tta -> ttc -> ttb
 * ============================================================ */
evaluate '[S5] ORDERED hint via transitive term: previously ignored (no edge tta-ttc), now applied correctly';
select /*+ recompile use_hash ordered */ count(*)
from tta, ttc, ttb
where tta.ca = ttb.ca
  and ttb.ca = ttc.ca;

/* ============================================================
 * Scenario 6: Constant substitution makes joins DUMMY_JOIN
 *
 * When ttc.ca = ttd.ca AND ttc.ca = 1, the optimizer substitutes the
 * constant and both sides become SARGs (ca = 1).  The join term
 * becomes QO_TC_DUMMY_JOIN, and the effective plan is a cross join
 * of single-row results.
 *
 * qo_collect_transitive_join_specs must detect group_all_dummy = true
 * and skip the group -- no transitive term should be added.
 * ============================================================ */

/* 2-table: join becomes DUMMY_JOIN via constant - baseline cross join */
evaluate '[S6-1] Constant subst 2-table: join becomes DUMMY_JOIN, cross join of single-row results (baseline)';
select /*+ recompile */ count(*)
from ttc, ttd
where ttc.ca = ttd.ca
  and ttc.ca = 1;

/* 3-table chain with constant: all joins become DUMMY_JOIN
 * transitive term ttc.ca=tta.ca must NOT be generated              */
evaluate '[S6-2] Constant subst 3-table: group_all_dummy detected, no transitive term generated for ttc.ca=tta.ca';
select /*+ recompile */ count(*)
from ttc, ttd, tta
where ttc.ca = ttd.ca
  and ttd.ca = tta.ca
  and ttc.ca = 1;

-- ===================================================================
-- Scenario 7: Self-join with table aliases
--
-- FROM tta a, tta b, ttc
-- WHERE a.ca = b.ca AND b.ca = ttc.ca
--
-- CBRD-26599 must generate a.ca = ttc.ca as a transitive term even
-- though 'a' and 'b' reference the same physical table (tta, 1M rows).
-- The transitive term connects alias 'a' directly to ttc (100 rows),
-- enabling ttc to be joined first as the filtering anchor.
-- ===================================================================
evaluate '[S7] Self-join aliases: transitive term generated across two aliases of the same physical table';
select /*+ recompile use_hash */ count(*)
from tta a, tta b, ttc
where a.ca = b.ca
  and b.ca = ttc.ca;

-- ===================================================================
-- Scenario 8: Multiple independent equivalence classes
--
-- Class 1 (column ca): tta.ca = ttb.ca AND ttb.ca = ttc.ca
--   -> generates tta.ca = ttc.ca
-- Class 2 (column cb): tta.cb = ttb.cb AND ttb.cb = ttd.ca
--   -> generates tta.cb = ttd.ca
--
-- The two classes must be handled independently with no cross-class
-- terms generated (e.g. tta.ca = ttd.ca must NOT appear).
-- Both ttc and ttd (100 rows each) should be used as early filters.
-- count(*) = 100: tta.ca limited to {1..100} by ttc (class 1).
--   Since tta.ca = tta.cb = rownum in the test data, the cb-chain
--   also selects the same 100 rows (constrained by ttd via class 2).
-- ===================================================================
evaluate '[S8] Multiple equivalence classes: ca-chain and cb-chain each produce their own transitive term independently';
select /*+ recompile use_hash */ count(*)
from tta, ttb, ttc, ttd
where tta.ca = ttb.ca
  and ttb.ca = ttc.ca
  and tta.cb = ttb.cb
  and ttb.cb = ttd.ca;

-- ===================================================================
-- Scenario 9: Non-equi join predicate mixed with equi join
--
-- WHERE tta.ca < ttb.ca AND ttb.ca = ttc.ca
--
-- The < predicate does NOT form an equivalence relationship, so
-- CBRD-26599 must NOT generate any transitive term involving tta.ca.
-- Only the equality ttb.ca = ttc.ca is valid for transitive inference.
--
-- Expected: ttc JOIN ttb first (ttc outer, ttb inner via ttb.ca=ttc.ca),
--           then tta probed with the inequality sarg (tta.ca < ttb.ca).
-- count(*) = 0+1+2+...+99 = 4950
-- ===================================================================
evaluate '[S9] Non-equi join: < predicate excluded from equivalence class, no spurious transitive term generated';
select /*+ recompile */ count(*)
from tta, ttb, ttc
where tta.ca < ttb.ca
  and ttb.ca = ttc.ca;

/* ============================================================
 * Scenario 10: Sort-limit with transitive join term
 *
 * sla(ca not null, indexed), slb(ca, indexed), slc(ca, cb, composite-indexed)
 * From sla.ca=slb.ca AND slb.ca=slc.ca, CBRD-26599 generates sla.ca=slc.ca,
 * enabling idx-join (sla desc_index outer, slc composite inner) to skip sort.
 * slc's multi-column schema exercises the parser_copy_tree fix.
 * ============================================================ */
evaluate '[S10 SETUP] Create indexed tables for sort-limit transitive term scenario';

drop table if exists sla;
drop table if exists slb;
drop table if exists slc;

create table sla (ca int not null);
create index i_sla_ca on sla (ca);
insert into sla select rownum from db_class a, db_class b limit 100;

create table slb (ca int not null);
create index i_slb_ca on slb (ca);
insert into slb select rownum from db_class a, db_class b limit 100;

create table slc (ca int not null, cb int);
create index i_slc on slc (ca, cb);
insert into slc select rownum, rownum from db_class a, db_class b limit 100;

update statistics on sla, slb, slc;

evaluate '[S10] 3-table sort-limit: transitive term sla.ca=slc.ca enables idx-join to skip ORDER BY sort';
select /*+ recompile */ sla.ca, slb.ca, slc.ca
from sla, slb, slc
where sla.ca > 0 and sla.ca = slb.ca and slb.ca = slc.ca
order by sla.ca desc limit 3;

-- ===================================================================
-- Cleanup
-- ===================================================================
evaluate '[CLEANUP] Drop all test tables';

drop table if exists sla;
drop table if exists slb;
drop table if exists slc;
drop table if exists tta;
drop table if exists ttb;
drop table if exists ttc;
drop table if exists ttd;
