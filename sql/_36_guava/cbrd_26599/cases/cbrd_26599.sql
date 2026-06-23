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

update statistics on nations, supp, cust, orders, part with fullscan;

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
--@fullplan
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

insert into t select rownum, rownum                    from db_class a, db_class b limit 1500;
insert into u select rownum, rownum % 1500 + 1, rownum from db_class a, db_class b, db_class c limit 2000;
insert into v select rownum, rownum % 1500 + 1, rownum from db_class a, db_class b, db_class c limit 2000;

update statistics on u, t, v with fullscan;

evaluate '[10] SORT-LIMIT preserved: implied t.i=v.j must not break PK-FK full-join';
select /*+ recompile NO_ELIMINATE_JOIN */ u.k
from u, t, v
where u.j = t.i and u.j = v.j
order by u.k limit 10;

drop table if exists u;
drop table if exists v;
drop table if exists t;

/* ============================================================
 * [11] Full 4-table join with no filtering predicate.
 *      cust.nk=supp.nk, supp.nk=nations.nk -> cust.nk=nations.nk auto-generated.
 *      With no region filter, all nations rows participate.
 * Verify: count(*)=800000.
 * ============================================================ */
evaluate '[11] full data join: no filter predicate, implied term still generated';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck;

/* ============================================================
 * [12] Higher-selectivity filter on nations (region > 1).
 *      region in 2..5 -> 20 of 25 nations rows pass the filter.
 *      Implied cust.nk=nations.nk lets nations filter early.
 * Verify: count(*)=640000, nations scanned first with region>1 sarg.
 * ============================================================ */
evaluate '[12] selective filter: nations.region > 1, implied term enables early filtering';
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and nations.region > 1;

/* ============================================================
 * [13] Host-variable binding: nations.region IN (?, ?, ?).
 *      Confirms implied-term generation and plan are correct when the
 *      filter values are supplied as bind variables.
 *      Run with (1,1,1) -> region=1 only, and (1,2,3) -> region in {1,2,3}.
 * Verify: (1,1,1) count(*)=160000, (1,2,3) count(*)=480000.
 * ============================================================ */
prepare q13 from 'select /*+ recompile use_hash */ count (*) from cust, supp, nations, orders where cust.nk = supp.nk and supp.nk = nations.nk and cust.ck = orders.ck and nations.region in ( ?, ?, ? )';

evaluate '[13-1] bind variables executes correctly';
--@queryplan
execute q13 using 1, 1, 1;
evaluate '[13-2] bind variables executes correctly';
--@queryplan
execute q13 using 1, 2, 3;
deallocate prepare q13;

/* ============================================================
 * [14] Eq-class spans INT (ta.i, tc.i) and VARCHAR (tb.v).
 *      The implied term must keep the result consistent with the chain.
 * Verify: count(*)=3.
 * ============================================================ */
drop table if exists ta;
drop table if exists tb;
drop table if exists tc;

create table ta (i int);
create table tb (v varchar(10));
create table tc (i int);

insert into ta values (1), (2), (3);
insert into tb values ('1'), ('2'), ('3');
insert into tc values (1), (2), (3);

update statistics on ta, tb, tc with fullscan;

evaluate '[14] cross-type eq-class (INT/VARCHAR): implied term must not change the matching set';
select /*+ recompile */ count (*)
from ta, tb, tc
where ta.i = tb.v
  and tb.v = tc.i;

drop table if exists ta;
drop table if exists tb;
drop table if exists tc;

/* ============================================================
 * [15] fc has a filtered index ON (nk) WHERE nk > 100.
 *      Range fa.nk in [1,50] propagates via the implied term to fc.nk,
 *      which violates the filter, so the filtered index must not be used.
 * Verify: count(*)=50 (no missing rows).
 * ============================================================ */
drop table if exists fa;
drop table if exists fb;
drop table if exists fc;

create table fa (nk int);
create table fb (nk int);
create table fc (nk int);

insert into fa select rownum from db_class a, db_class b limit 50;
insert into fb select rownum from db_class a, db_class b limit 200;
insert into fc select rownum from db_class a, db_class b limit 200;

create index fidx_fc on fc (nk) where nk > 100;

evaluate '[15] filtered index (nk>100): range propagated via implied term must not wrongly enable the filtered index';
select /*+ recompile */ count (*)
from fa, fb, fc
where fa.nk = fb.nk
  and fb.nk = fc.nk
  and fa.nk between 1 and 50;

drop table if exists fa;
drop table if exists fb;
drop table if exists fc;

/* ============================================================
 * [16] sk_a and sk_b have a skewed key (nk=1 is 90% of rows).
 *      Implied sk_a.nk=sk_b.nk connects the two skewed tables directly,
 *      which may mislead the NDV-based cost model into a bad join order.
 * Verify: count(*)=820000, watch the join order in the plan.
 * ============================================================ */
drop table if exists sk_a;
drop table if exists sk_b;
drop table if exists sk_dim;

create table sk_a (nk int);
create table sk_b (nk int);
create table sk_dim (nk int);

insert into sk_a select 1 from db_class a, db_class b limit 900;
insert into sk_a select 2 from db_class a, db_class b limit 100;
insert into sk_b select 1 from db_class a, db_class b limit 900;
insert into sk_b select 2 from db_class a, db_class b limit 100;
insert into sk_dim values (1), (2);

update statistics on sk_a, sk_b, sk_dim with fullscan;

evaluate '[16] data skew: implied term connects two skewed tables - watch for exploding intermediate cardinality';
select /*+ recompile use_hash */ count (*)
from sk_a, sk_dim, sk_b
where sk_a.nk = sk_dim.nk
  and sk_dim.nk = sk_b.nk;

drop table if exists sk_a;
drop table if exists sk_b;
drop table if exists sk_dim;

/* ============================================================
 * [17] Under USE_NL, implied nl_a.nk=nl_b.nk adds a direct edge
 *      between the two tables. Watch that the nested loop does not
 *      start on nl_a x nl_b before applying the bridge nl_m.
 * Verify: count(*)=300, check the nested-loop join order.
 * ============================================================ */
drop table if exists nl_a;
drop table if exists nl_m;
drop table if exists nl_b;

create table nl_a (nk int);
create table nl_m (nk int);
create table nl_b (nk int);

insert into nl_a select rownum from db_class a, db_class b limit 300;
insert into nl_m select rownum from db_class a, db_class b limit 300;
insert into nl_b select rownum from db_class a, db_class b limit 300;

update statistics on nl_a, nl_m, nl_b with fullscan;

evaluate '[17] USE_NL: implied edge between nl_a and nl_b - watch nested-loop join order';
select /*+ recompile use_nl */ count (*)
from nl_a, nl_m, nl_b
where nl_a.nk = nl_m.nk
  and nl_m.nk = nl_b.nk;

drop table if exists nl_a;
drop table if exists nl_m;
drop table if exists nl_b;

/* ============================================================
 * [18] Implied term used as an index key.
 *      keytab has a composite index on (nk, x). The query filters only on x,
 *      and joins keytab -> bridge -> anchor on nk (anchor has nk=7).
 *      The implied keytab.nk = anchor.nk (=7) fills in the leading index
 *      column, so the composite index is used with both keys (nk=7, x=10).
 * Verify: count(*)=1, plan reads keytab through its (nk, x) index.
 * ============================================================ */
drop table if exists keytab;
drop table if exists bridge;
drop table if exists anchor;

create table keytab (nk int, x int);
create index ix_keytab on keytab (nk, x);
insert into keytab select (rownum-1)/50 + 1, mod(rownum-1,50)+1 from db_class a, db_class b limit 1000;

create table bridge (nk int);
insert into bridge select rownum from db_class a limit 20;

create table anchor (nk int);
insert into anchor values (7);

update statistics on keytab, bridge, anchor with fullscan;

evaluate '[18] implied term used as an index key on a composite (nk, x) index';
select /*+ recompile */ count (*)
from keytab, bridge, anchor
where keytab.nk = bridge.nk
  and bridge.nk = anchor.nk
  and keytab.x = 10;

drop table if exists keytab;
drop table if exists bridge;
drop table if exists anchor;

/* ============================================================
 * [19] Chain crosses a derived table dv = (select nk from supp).
 *      After merging, cust.nk=nations.nk must be generated correctly.
 * Verify: count(*)=80000.
 * ============================================================ */
evaluate '[19] derived-table boundary: implied cust.nk=nations.nk generated after merging';
--@fullplan
select /*+ recompile use_hash */ count (*)
from cust, (select nk from supp) dv, nations
where cust.nk = dv.nk
  and dv.nk = nations.nk
  and nations.region = 1;

/* ============================================================
 * [20] View boundary - implied term yields the smallest intermediate.
 *      v_supp (view over supp) and nations have NO written edge: they
 *      connect only through cust (the large middle table) via
 *      v_supp.nk=cust.nk and cust.nk=nations.nk.
 *      After view merging the implied v_supp.nk=nations.nk is generated,
 *      letting the small v_supp and the filtered nations (region=1) join
 *      first instead of routing through cust -> smallest intermediate.
 * Verify: count(*)=80000, join graph shows implied v_supp.nk=nations.nk
 *         and the plan joins v_supp with nations early.
 * ============================================================ */
drop view if exists v_supp;
create view v_supp as select nk from supp;

evaluate '[20] view boundary: implied v_supp.nk=nations.nk yields smallest intermediate';
select /*+ recompile use_hash */ count (*)
from v_supp, cust, nations
where v_supp.nk = cust.nk
  and cust.nk = nations.nk
  and nations.region = 1;

drop view if exists v_supp;

/* ============================================================
 * [21] Two independent 3-member eqclasses, both generate implied terms.
 *      Group A (nk): cust.nk=supp.nk, supp.nk=nations.nk -> cust.nk=nations.nk
 *      Group B (ck): cust.ck=orders.ck, orders.ck=part_ck.ck -> cust.ck=part_ck.ck
 *      Cross-contamination (e.g. cust.nk=orders.ck) must NOT occur.
 * Verify: count(*)=8000, join graph shows two separate eqclasses each with its own implied term.
 * ============================================================ */
drop table if exists part_ck;
create table part_ck (pk int, ck int);
insert into part_ck select rownum, mod(rownum-1, 10000)+1 from db_class a, db_class b limit 500;
update statistics on part_ck with fullscan;

evaluate '[21] two 3-member eqclasses - cross-contamination check';
--@fullplan
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, orders, part_ck
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and cust.ck = orders.ck
  and orders.ck = part_ck.ck
  and nations.region = 1;

drop table if exists part_ck;

/* ============================================================
 * [22] 5-table query: nk chain (cust-supp-nations-part, same as [3])
 *      plus a separate ck path (cust-orders).
 *      All nk implied terms must still be generated with both paths present.
 * Verify: count(*)=3200000, plan optimal with implied terms in the nk eqclass.
 * ============================================================ */
evaluate '[22] 5-table full chain - large eqclass with mixed join paths';
--@fullplan
select /*+ recompile use_hash */ count (*)
from cust, supp, nations, part, orders
where cust.nk = supp.nk
  and supp.nk = nations.nk
  and nations.nk = part.nk
  and cust.ck = orders.ck
  and nations.region = 1;

-- ===================================================================
-- Cleanup
-- ===================================================================
evaluate '[CLEANUP] Drop all test tables';

drop table if exists orders;
drop table if exists part;
drop table if exists cust;
drop table if exists supp;
drop table if exists nations;
