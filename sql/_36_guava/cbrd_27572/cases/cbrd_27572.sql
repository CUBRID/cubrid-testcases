/*
 * This test case verifies CBRD-27572 : a correlated scalar subquery with GROUP BY
 * or an analytic function, evaluated in the condition of the inner table of a
 * nested loop join, fails with "Internal system failure" (debug build: assert in
 * qfile_update_domains_on_type_list, latest develop release: server crash in
 * qexec_hash_gby_agg_tuple).
 *
 * Bug: since CBRD-26522 the list file of a correlated subquery attached to an
 * NL inner scan is truncated and reused for every inner row instead of being
 * destroyed. A truncated list keeps its type_list, so the next execution does
 * not open it again. GROUP BY and analytic functions replace the list file with
 * the result list (a different shape) at the end of each execution, so the next
 * inner row writes scan tuples (group key + aggregate argument) into a list of
 * the result shape. Set operations replace the list file the same way, and
 * ORDER BY / DISTINCT leave a sort_list on it.
 *
 * Fix: the truncate reuse is kept only for BUILDVALUE and for plain BUILDLIST
 * subqueries (no GROUP BY, analytic function, ORDER BY or DISTINCT). The other
 * subqueries destroy their list file per inner row as before CBRD-26522.
 *
 * Every NL join below has 10 inner (o1) rows per outer (o0) row, so the
 * subquery runs again on a reused list file. Each NL query is followed by the
 * same subquery evaluated on table j, which holds the 100 join rows and runs
 * the subquery at the root node (no truncate reuse). Both must give the same
 * result. use_nl / ordered / using index fix o1 as the NL inner scan,
 * no_subquery_cache makes the subquery run for every inner row, and
 * memoize_memory_limit=0 keeps memoize from skipping inner scans.
 *   Case 1: group key has an outer column (scan 2 columns / result 1) -> 80
 *   Case 2: outer column only in HAVING (scan 2 columns / result 1) -> 70, 880
 *   Case 3: count(*) GROUP BY, same column count, scan INTEGER / result BIGINT
 *           -> 90, 1320
 *   Case 4: analytic function (scan 2 columns / result 1) -> 34, 538
 *   Case 5: DISTINCT -> 87, 1230
 *   Case 6: UNION -> 80, 1310
 *   Case 7: ORDER BY + LIMIT without GROUP BY -> 27, 435
 *   Case 8: plain list subquery, still truncated and reused -> 38, 632
 *   Case 9: aggregate without GROUP BY (BUILDVALUE), still truncated and reused
 *           -> 27, 435
 */
drop table if exists cz, cx, cs, j;
create table cz (nu int);
insert into cz values (1);
create table cx (pk int primary key, nn int not null, nu int);
insert into cx select rownum, mod(rownum, 13), mod(rownum, 3) from db_class a, db_class b limit 30;
create index i_cx_nu on cx (nu);
create table cs (pk int primary key, v int);
insert into cs values (1, 1), (2, 2), (3, 3), (4, 4);
create table j as select o0.nn onn, o1.pk opk, o1.nn onn1 from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu;
update statistics on cz, cx, cs, j with fullscan;
set system parameters 'memoize_memory_limit=0';

--test: Case 1: group key has an outer column, ORDER BY + LIMIT
--@queryplan
select /*+ recompile use_nl ordered */ count(*)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.pk <= o1.pk group by mod(cs.v + o0.nn, 2) order by 1 limit 1), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.pk <= j.opk group by mod(cs.v + j.onn, 2) order by 1 limit 1), 0);

--test: Case 2: outer column only in HAVING
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.pk <= o1.pk group by cs.pk / 100 having max(cs.v) > mod(o0.nn, 4)), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.pk <= j.opk group by cs.pk / 100 having max(cs.v) > mod(j.onn, 4)), 0);

--test: Case 3: count(*) GROUP BY, result type differs from scan column type
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ count(*) from cs where cs.pk <= o1.pk group by mod(cs.v, 2) order by 1 desc limit 1), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ count(*) from cs where cs.pk <= j.opk group by mod(cs.v, 2) order by 1 desc limit 1), 0);

--test: Case 4: analytic function
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v + o0.nn) over (partition by mod(cs.v, 2)) from cs where cs.pk <= o1.pk order by 1 limit 1), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ max(cs.v + j.onn) over (partition by mod(cs.v, 2)) from cs where cs.pk <= j.opk order by 1 limit 1), 0);

--test: Case 5: DISTINCT
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ distinct cs.v from cs where cs.pk <= o1.pk and cs.v = mod(o0.nn, 5)), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ distinct cs.v from cs where cs.pk <= j.opk and cs.v = mod(j.onn, 5)), 0);

--test: Case 6: UNION
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ cs.v from cs where cs.pk = mod(o1.pk, 4) + 1 union select cs.v from cs where cs.pk = mod(o1.pk, 4) + 1 and o0.nn >= 0), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ cs.v from cs where cs.pk = mod(j.opk, 4) + 1 union select cs.v from cs where cs.pk = mod(j.opk, 4) + 1 and j.onn >= 0), 0);

--test: Case 7: ORDER BY + LIMIT without GROUP BY
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ cs.v + o0.nn from cs where cs.pk <= o1.pk order by cs.v desc limit 1), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ cs.v + j.onn from cs where cs.pk <= j.opk order by cs.v desc limit 1), 0);

--test: Case 8: plain list subquery, list file is still truncated and reused
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ cs.v + o0.nn from cs where cs.pk = mod(o1.pk, 4) + 1), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ cs.v + j.onn from cs where cs.pk = mod(j.opk, 4) + 1), 0);

--test: Case 9: aggregate without GROUP BY, list file is still truncated and reused
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk)
  from cz z, cx o0, cx o1
 where z.nu = o0.nu and o0.nu = o1.nu
   and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v + o0.nn) from cs where cs.pk <= o1.pk), 0)
 using index o0.i_cx_nu, o1.i_cx_nu;
select /*+ recompile */ count(*), sum(j.opk) from j
 where j.onn1 >= nvl((select /*+ no_subquery_cache */ max(cs.v + j.onn) from cs where cs.pk <= j.opk), 0);

set system parameters 'memoize_memory_limit=2M';
drop table cz, cx, cs, j;
