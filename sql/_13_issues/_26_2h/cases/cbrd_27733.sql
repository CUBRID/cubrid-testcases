/**
 *  This test case verifies CBRD-27733: correlated aggregate HAVING results
 *  depend on each outer row, not on another row sharing its search key.
 *  Compare default scalar subqueries with NO_SUBQUERY_CACHE reference twins
 *  and independently computed literal values, including SQL NULL.
 *  This is a correctness test: no plan token or cache hit count is required.
 *  Output order does not by itself prove scalar evaluation order.
 *  Coverage:
 *    Case 1: Baseline pair, ascending output
 *    Case 2: Baseline pair, descending output
 *    Case 3: All baseline rows, ascending output
 *    Case 4: All baseline rows, descending output
 *    Case 5: Pair with true and false thresholds exchanged
 *    Case 6: All rows with true and false thresholds exchanged
 *    Case 7: Thresholds below, equal to and above each key maximum
 *    Case 8: Reversed assignment of boundary thresholds
 *    Case 9: NULL and true thresholds for each key
 *    Case 10: Exchanged NULL and true thresholds for each key
 */

drop table if exists t_outer, t_inner, t_seed;

-- Ten seed rows generate exact finite input sizes, without catalog-size assumptions
create table t_seed (d int);

insert into t_seed values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- Twenty outer rows repeat each search key with different HAVING thresholds
create table t_outer (id int primary key, k int, t int);

insert into t_outer select rownum, mod(rownum, 10), case when rownum <= 10 then 0 else 1000 end from t_seed sa, t_seed sb limit 20;

-- Exactly one thousand rows give distinct integer maxima for the ten keys
create table t_inner (k int, v int);

insert into t_inner select mod(rownum, 10), rownum from t_seed sa, t_seed sb, t_seed sc;

create index idx_k on t_inner(k);

update statistics on t_outer, t_inner with fullscan;

evaluate 'Case 1: baseline pair ascending; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id;

evaluate 'Case 2: baseline pair descending; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id desc;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id desc;

evaluate 'Case 3: baseline full ascending; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

evaluate 'Case 4: baseline full descending; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id desc;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id desc;

update t_outer set t = 1000 - t;

update statistics on t_outer with fullscan;

evaluate 'Case 5: exchanged pair thresholds; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo where oo.id in (1, 11) order by oo.id;

evaluate 'Case 6: exchanged full thresholds; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

delete from t_outer;

insert into t_outer values (1, 1, 990), (2, 2, 991), (3, 3, 992), (4, 4, 993), (5, 5, 994), (6, 6, 995), (7, 7, 996), (8, 8, 997), (9, 9, 998), (10, 0, 999), (11, 1, 991), (12, 2, 992), (13, 3, 993), (14, 4, 994), (15, 5, 995), (16, 6, 996), (17, 7, 997), (18, 8, 998), (19, 9, 999), (20, 0, 1000), (21, 1, 992), (22, 2, 993), (23, 3, 994), (24, 4, 995), (25, 5, 996), (26, 6, 997), (27, 7, 998), (28, 8, 999), (29, 9, 1000), (30, 0, 1001);

update statistics on t_outer with fullscan;

evaluate 'Case 7: MAX minus one equal and plus one; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

update t_outer set t = t + case when id <= 10 then 2 when id > 20 then -2 else 0 end;

update statistics on t_outer with fullscan;

evaluate 'Case 8: exchanged boundary thresholds; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

delete from t_outer where id > 20;

update t_outer set t = case when id <= 10 then NULL else 0 end;

update statistics on t_outer with fullscan;

evaluate 'Case 9: NULL then true thresholds; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

update t_outer set t = case when id <= 10 then 0 else NULL end;

update statistics on t_outer with fullscan;

evaluate 'Case 10: true then NULL thresholds; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, oo.t, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, oo.t, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.t) as x from t_outer oo order by oo.id;

drop table t_outer, t_inner, t_seed;
