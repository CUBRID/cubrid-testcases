/*
 * CBRD-26599: Implied (transitive-closure) Join Term Generation - plan verification.
 *
 * Verifies that qo_generate_implied_join_terms() generates implicit join
 * predicates for the missing node pairs of each segment equivalence group, and
 * that the optimizer (after qo_discover_edges() folds the new terms into the
 * edge zone) can reach a cheaper join order as a result.
 *
 * SCHEMA (fanout design - so the implied term yields a REAL cost benefit,
 *         sizes kept small for CI, NDV=25 and region 5/25 selectivity preserved):
 *   nations(nk,region) : 25 rows, nk UNIQUE 1..25, region 1..5  (selective dim)
 *   supp(sk,nk)        : 1k rows,  nk NDV 25  (fanout key)
 *   cust(ck,nk)        : 10k rows, nk NDV 25  (fanout key, larger fact)
 *   orders(ok,ck)      : 20k rows, joins cust.ck (compounds early filtering)
 *   part(pk,nk)        : 500 rows, nk NDV 25   (4th member for multi-hop test)
 */

-- ===================================================================
-- Setup
-- ===================================================================
evaluate '[SETUP] Create and populate test tables';

drop table if exists orders;
drop table if exists part;
drop table if exists cust;
drop table if exists supp;
drop table if exists nations;

-- ===== Table definitions ===== 
--dimension: nk unique, region 1..5
create table nations (nk int, region int);
--fanout key nk (NDV 25)
create table supp    (sk int, nk int);
--larger fact, fanout key nk
create table cust    (ck int, nk int);
--joins cust on ck
create table orders  (ok int, ck int);
--4th member of the nk eqclass
create table part    (pk int, nk int);

insert into nations select rownum, (rownum-1)/5 + 1      from db_class a limit 25;
insert into supp    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b limit 1000;
insert into cust    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b, db_class c limit 10000;
insert into orders  select rownum, mod(rownum-1,10000)+1 from db_class a, db_class b, db_class c limit 20000;
insert into part    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b limit 500;

update statistics on nations, supp, cust, orders, part;

/* ============================================================
 * (1) Implied term generation + cost benefit - implicit JOIN syntax
 *
 * eqclass {cust.nk, supp.nk, nations.nk}. Written edges: cust-supp, supp-nations.
 * Implied term cust.nk = nations.nk is generated.
 *
 * With the region filter (5 of 25 nk) and the extra cust<->orders join:
 *   with feature    : cust JOIN nations (implied edge) runs early, filtering
 *                     cust to the 5 region nk values BEFORE orders/supp, so the
 *                     cust<->supp fanout never materializes in full.
 *   without feature : cust has no edge to nations, so the only path is
 *                     supp -> nations -> cust -> orders (cust stays unfiltered
 *                     through the cust<->supp fanout) - markedly more expensive.
 * ============================================================ */
evaluate '[1-1] implied term generated + used: cust JOIN nations early (implicit syntax)';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and nations.region = 1;

/* same query, explicit JOIN syntax - must generate the same implied term */
evaluate '[1-2] implied term generated + used: explicit join syntax';
select /*+ recompile use_hash */ count (*)
from cust
  join supp    on cust.nk = supp.nk
  join nations on supp.nk = nations.nk
  join orders  on cust.ck = orders.ck
where nations.region = 1;

/* ============================================================
 * (2) Implied term already present explicitly in WHERE
 *
 * cust.nk = nations.nk is supplied by the user.  qo_collect_implied_join_pairs()
 * must NOT add a duplicate (already_has_term check); plan stays correct.
 * ============================================================ */
evaluate '[2] implied term already explicit - no duplicate term added';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * (3) Multi-hop: 4-member equivalence class
 *
 * cust.nk=supp.nk, supp.nk=nations.nk, nations.nk=part.nk
 *   -> eqclass {cust,supp,nations,part}
 *   -> 3 implied terms for the missing pairs:
 *        cust.nk=nations.nk, cust.nk=part.nk, supp.nk=part.nk
 * ============================================================ */
evaluate '[3] 4-member eqclass - all missing-pair implied terms generated';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, part
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and nations.nk = part.nk
  and nations.region = 1;

/* ============================================================
 * (4) Outer-join boundary - implied term must NOT cross it
 *
 * cust LEFT OUTER JOIN supp ON cust.nk=supp.nk, then INNER nations ON supp.nk=nations.nk.
 * supp rows may be NULL under the outer join, so deriving cust.nk=nations.nk is
 * unsound.  qo_build_implied_seg_roots() seeds the union-find with unconditional
 * inner edges only, so the outer/after-join edge does NOT seed the closure and
 * cust.nk=nations.nk is NOT generated.
 * ============================================================ */
evaluate '[4] outer-join boundary - implied term must NOT be generated across outer join';
select /*+ recompile use_hash */ count (*)
from cust
  left outer join supp on cust.nk = supp.nk
  inner join nations on supp.nk = nations.nk;

/* ============================================================
 * (5) ORDERED hint enabled by the implied term
 *
 * FROM order cust, nations, supp : cust->nations has no explicit join term.
 *   without feature : ORDERED ignored (no edge between cust and nations)
 *   with feature    : implied cust.nk=nations.nk supplies the edge, so ORDERED
 *                     is honored -> join proceeds cust -> nations -> supp.
 * ============================================================ */
evaluate '[5] ORDERED hint honored via implied term (cust -> nations -> supp)';
select /*+ recompile use_hash ordered */ count (*)
from cust, nations, supp
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * (6) Constant substitution -> no implied term
 *
 * With cust.nk = <const>, qo_reduce_equality_terms propagates the constant and
 * flags the rewritten equi-join terms with PT_EXPR_INFO_TRANSITIVE.
 * qo_build_implied_seg_roots() skips PT_EXPR_INFO_TRANSITIVE terms when seeding
 * the union-find, so no implied term is generated (the joins collapse to
 * single-value SARGs / DUMMY_JOIN).
 * ============================================================ */
evaluate '[6] constant subst 3-table - PT_EXPR_INFO_TRANSITIVE excluded, no implied term';
select /*+ recompile */ count(*)
from cust, supp, nations
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.nk = 5;

-- ===================================================================
-- Scenario 7: Self-join with table aliases
--
-- FROM supp a, supp b, nations WHERE a.nk=b.nk AND b.nk=nations.nk
--
-- qo_generate_implied_join_terms() must generate a.nk=nations.nk even
-- though a and b reference the same physical table (supp, 1k rows).
-- The implied term connects alias a directly to nations (5 rows with
-- region=1), enabling nations to be joined first as the filtering anchor.
-- ===================================================================
evaluate '[7] self-join aliases: implied term generated across two aliases of the same physical table';
select /*+ recompile use_hash */ count (*)
from supp a, supp b, nations
where a.nk = b.nk
  and b.nk = nations.nk
  and nations.region = 1;

-- ===================================================================
-- Scenario 8: Two independent equivalence classes (star topology + ck chain)
--
-- Written edges: cust.nk=nations.nk, supp.nk=nations.nk (star: both connect
-- directly to nations), AND cust.ck=orders.ck.
--
-- eqclass[0] (nk): {cust.nk, supp.nk, nations.nk}
--   -> missing pair cust-supp -> implied term cust.nk=supp.nk generated.
--   -> topology differs from (1): original edges are cust-nations and
--      supp-nations (star), not cust-supp and supp-nations (chain).
--
-- eqclass[1] (ck): {cust.ck, orders.ck}
--   -> 2-node class, no implied term possible.
--   -> must remain independent: no cross-contamination with eqclass[0].
-- ===================================================================
evaluate '[8] star topology + ck chain: two independent eqclasses, implied cust.nk=supp.nk generated';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = nations.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and nations.region = 1;

-- ===================================================================
-- Scenario 9: Non-equi join predicate mixed with equi join
--
-- WHERE supp.nk < nations.nk AND nations.nk = part.nk AND nations.region=1
--
-- The < predicate does NOT form an equivalence relationship, so
-- qo_generate_implied_join_terms() must NOT generate any implied term
-- involving supp.nk.  Only the equality nations.nk=part.nk is valid, but
-- that is a 2-node class and produces no implied term.
--
-- If < were =: eqclass {supp.nk, nations.nk, part.nk} -> supp.nk=part.nk implied.
-- With <     : eqclass {nations.nk, part.nk} only -> NO implied term.
--
-- Expected: nations (5 rows) joined with part first (equi), then supp
--           probed with the inequality sarg (supp.nk < nations.nk).
-- count(*) = 8000
-- ===================================================================
evaluate '[9] non-equi join: < predicate excluded from eq-class, no spurious implied term';
select /*+ recompile */ count (*)
from supp, nations, part
where supp.nk < nations.nk
  and nations.nk = part.nk
  and nations.region = 1;

/* ============================================================
 * (10) SORT-LIMIT preserved by QO_TERM_IMPLIED (PK-FK full-join check)
 *
 * t(i PK), u(j -> FK t.i, k), v(plain table, non-unique j).
 *   u.j = t.i  AND  u.j = v.j  ->  eqclass {u.j, t.i, v.j}
 *   -> implied term  t.i = v.j  is generated.
 *
 * The SORT-LIMIT optimization (ORDER BY u.k LIMIT) applies here only because:
 *   1. t is PK-FK full-joined to u, so it can be DEFERRED past the sort-limit.
 *      The implied term t.i=v.j references {t,v} (not u) and would make
 *      qo_is_pk_fk_full_join(u,t) return false -> t NOT deferred ->
 *      sort_limit_nodes = all nodes -> SORT-LIMIT abandoned (the regression).
 *      QO_TERM_IMPLIED makes that check SKIP the implied term, so t stays
 *      deferrable.  THIS is what this case guards.
 *   2. v is a plain table (non-unique join key), so it is NOT a PK-FK full join.
 *      it stays in sort_limit_nodes -> {u,v} is a proper subset (not abandoned),
 *      and u<->v fans out, making the early sort-limit cost-favorable.
 *
 * Expected: a "temp(sort limit)" node over (u join v), with t joined afterwards
 * (deferred).  NO_ELIMINATE_JOIN keeps t/v from being optimized away.
 * ============================================================ */
drop table if exists u;
drop table if exists v;
drop table if exists t;

create table t (i int primary key, j int);
create table u (i int primary key, j int not null, k int, foreign key fk_u_t (j) references t (i));
--plain table: no PK, non-unique j -> fanout
create table v (i int, j int, k int);  

insert into t select rownum, rownum                    from _db_class a, _db_class b limit 1500;
insert into u select rownum, rownum % 1500 + 1, rownum from _db_class a, _db_class b, _db_class c limit 2000;
insert into v select rownum, rownum % 1500 + 1, rownum from _db_class a, _db_class b, _db_class c limit 2000;

update statistics on u, t, v;

evaluate '[10] SORT-LIMIT preserved: implied t.i=v.j must not break PK-FK full-join';
select /*+ recompile NO_ELIMINATE_JOIN */ u.k
from u, t, v
where u.j = t.i and u.j = v.j
order by u.k limit 10;

drop table u;
drop table v;
drop table t;

-- ===================================================================
-- Cleanup
-- ===================================================================
evaluate '[CLEANUP] Drop all test tables';

drop table if exists orders;
drop table if exists part;
drop table if exists cust;
drop table if exists supp;
drop table if exists nations;
