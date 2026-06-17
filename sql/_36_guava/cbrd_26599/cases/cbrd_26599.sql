/*
 * CBRD-26599: Implied Join Term Auto-Generation - Query Plan Verification
 *
 * When a user writes only "A.nk = B.nk AND B.nk = C.nk", the optimizer
 * now automatically adds the missing "A.nk = C.nk" to enable a cheaper join order.
 *
 * Schema:
 *   nations(nk,region) : 25 rows, nk 1..25, region 1..5  (small filtering table)
 *   supp(sk,nk)        : 1k rows,  nk NDV 25
 *   cust(ck,nk)        : 10k rows, nk NDV 25  (large fact table)
 *   orders(ok,ck)      : 20k rows, joins on cust.ck
 *   part(pk,nk)        : 500 rows, nk NDV 25  (4th table for multi-hop test)
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
-- small filtering table: nk 1..25, region 1..5
create table nations (nk int, region int);
-- fanout key nk (NDV 25)
create table supp    (sk int, nk int);
-- large fact table, fanout key nk
create table cust    (ck int, nk int);
-- joins on cust.ck
create table orders  (ok int, ck int);
-- 4th table for multi-hop test
create table part    (pk int, nk int);

insert into nations select rownum, (rownum-1)/5 + 1      from db_class a limit 25;
insert into supp    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b limit 1000;
insert into cust    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b, db_class c limit 10000;
insert into orders  select rownum, mod(rownum-1,10000)+1 from db_class a, db_class b, db_class c limit 20000;
insert into part    select rownum, mod(rownum-1,25)+1    from db_class a, db_class b limit 500;

update statistics on nations, supp, cust, orders, part;

/* ============================================================
 * [1-1] Basic implied term: cust.nk=supp.nk, supp.nk=nations.nk
 *       -> cust.nk=nations.nk auto-generated, nations joined early with region filter.
 * Verify: count(*)=160000, nations is the first inner scan with sargs.
 * ============================================================ */
evaluate '[1-1] implied term generated + used: cust JOIN nations early (implicit syntax)';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and nations.region = 1;

/* ============================================================
 * [1-2] Same query as [1-1] with explicit JOIN syntax.
 * Verify: count(*)=160000, same plan as [1-1].
 * ============================================================ */
evaluate '[1-2] implied term generated + used: explicit join syntax';
select /*+ recompile use_hash */ count (*)
from cust
  join supp    on cust.nk = supp.nk
  join nations on supp.nk = nations.nk
  join orders  on cust.ck = orders.ck
where nations.region = 1;

/* ============================================================
 * [2] cust.nk=nations.nk already written by user.
 *     -> no duplicate auto-generated condition added.
 * Verify: count(*)=80000, plan generated correctly.
 * ============================================================ */
evaluate '[2] implied term already explicit - no duplicate term added';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * [3] 4-table chain: cust-supp-nations-part.
 *     -> all 3 missing pairs auto-generated:
 *        cust.nk=nations.nk, cust.nk=part.nk, supp.nk=part.nk.
 * Verify: count(*)=1600000, join graph shows all 3 implied terms.
 * ============================================================ */
evaluate '[3] 4-member eqclass - all missing-pair implied terms generated';
--@fullplan
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, part
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and nations.nk = part.nk
  and nations.region = 1;

/* ============================================================
 * [4] LEFT OUTER JOIN: supp may be NULL, so cust.nk=nations.nk
 *     must NOT be auto-generated across the outer join boundary.
 * Verify: count(*)=400000, nations joined last (outer join structure preserved).
 * ============================================================ */
evaluate '[4] outer-join boundary - implied term must NOT be generated across outer join';
select /*+ recompile use_hash */ count (*)
from cust
  left outer join supp on cust.nk = supp.nk
  inner join nations on supp.nk = nations.nk;

/* ============================================================
 * [5] FROM order: cust, nations, supp. No direct cust-nations condition.
 *     -> cust.nk=nations.nk auto-generated, ORDERED hint now honored.
 * Verify: count(*)=80000, plan follows cust->nations->supp, no HINT warning.
 * ============================================================ */
evaluate '[5] ORDERED hint honored via implied term (cust -> nations -> supp)';
select /*+ recompile use_hash ordered */ count (*)
from cust, nations, supp
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * [6] Constant cust.nk=5 propagates to all join conditions (supp.nk=5,
 *     nations.nk=5), collapsing joins to single-value lookups (DUMMY_JOIN).
 *     -> no auto-generated condition created.
 * Verify: count(*)=16000, join graph shows dummy join terms only, nl-join (cross join).
 * ============================================================ */
evaluate '[6] constant subst 3-table - PT_EXPR_INFO_TRANSITIVE excluded, no implied term';
--@fullplan
select /*+ recompile */ count(*)
from cust, supp, nations
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.nk = 5;

/* ============================================================
 * [7] Same physical table (supp) under two aliases a, b.
 *     -> a.nk=nations.nk auto-generated, nations joined first as filtering anchor.
 * Verify: count(*)=8000, plan shows a->nations->b order.
 * ============================================================ */
evaluate '[7] self-join aliases: implied term generated across two aliases of the same physical table';
select /*+ recompile use_hash */ count (*)
from supp a, supp b, nations
where a.nk = b.nk
  and b.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * [8] Two independent groups in one query (star nk + ck chain).
 *     Group 1 (nk star): cust.nk=nations.nk, supp.nk=nations.nk
 *       -> missing pair: cust.nk=supp.nk auto-generated.
 *     Group 2 (ck): cust.ck=orders.ck (2-node, no auto-generation).
 *     -> two groups must stay independent (no cross-contamination).
 * Verify: count(*)=160000, join graph shows eqclass[0](nk) and eqclass[1](ck) separate.
 * ============================================================ */
evaluate '[8] star topology + ck chain: two independent eqclasses, implied cust.nk=supp.nk generated';
--@fullplan
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = nations.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and nations.region = 1;

/* ============================================================
 * [9] supp.nk < nations.nk is an inequality, so supp.nk is excluded
 *     from the equality group -> no auto-generated condition involving supp.nk.
 *     (If < were =, supp.nk=part.nk would be spuriously generated.)
 * Verify: count(*)=8000, nl-join (no equi-join), supp scanned with inequality sarg.
 * ============================================================ */
evaluate '[9] non-equi join: < predicate excluded from eq-class, no spurious implied term';
select /*+ recompile */ count (*)
from supp, nations, part
where supp.nk < nations.nk
  and nations.nk = part.nk
  and nations.region = 1;

/* ============================================================
 * [10] u.j=t.i AND u.j=v.j -> t.i=v.j auto-generated.
 *      Without the fix, this broke the PK-FK full-join check on (u,t),
 *      causing t to lose its deferred status and the SORT-LIMIT to be abandoned.
 *      After the fix, auto-generated conditions are excluded from that check,
 *      so t stays deferrable and SORT-LIMIT over (v join u) is preserved.
 * Verify: u.k=1,1,2,2,3,3,4,4,5,5, plan shows temp(sort limit) over (v join u),
 *         t joined afterwards (deferred).
 * ============================================================ */
drop table if exists u;
drop table if exists v;
drop table if exists t;

create table t (i int primary key, j int);
create table u (i int primary key, j int not null, k int, foreign key fk_u_t (j) references t (i));
-- no PK, non-unique j -> fanout
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
