/**
 *  This test case verifies CBRD-28211: a GROUP BY skipped by a backward index scan keeps the backward
 *  scan when an ORDER BY or a DISTINCT that is not skipped sorts its result.
 *
 *  Before the fix the sort plan put over the GROUP BY skip plan dropped the scan direction, so the
 *  index was read forwards (no desc_index in the trace). Serially the groups were still contiguous,
 *  but a parallel index scan closed a run at every group, and the leader's merge of one run per group
 *  ran out of buffers (hang, -1123, debug assert).
 *
 *  Each tested query is followed by its twin with no_parallel_scan on every query block. The results
 *  must match. The proof is desc_index: true on the index scan with GROUPBY (no hash, no sort).
 *  rownum weighs every row by its position, so a row out of ORDER BY order changes the sum.
 *
 *  Coverage:
 *    Case 1: GROUP BY a DESC over an ascending index, ORDER BY another column, covered and not covered
 *    Case 2: GROUP BY a DESC over an ascending index with DISTINCT
 *    Case 3: GROUP BY a ASC over a descending index, ORDER BY another column
 *    Case 4: GROUP BY a DESC, b DESC, c DESC WITH ROLLUP over an ascending index, ORDER BY a, b, c
 *    Case 5: GROUP BY a ASC over an ascending index, ORDER BY another column, read forwards as before
 */

drop table if exists t_digit, t_sk, t_skd;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200000 rows: a has 40000 keys of 5 rows and is NULL on every eleventh row
create table t_sk (id int primary key, a int, b int, c int, v int);
insert into t_sk select rownum, case when mod(rownum, 11) = 0 then null else mod(rownum, 40000) end, case when mod(rownum, 5) = 0 then null else mod(rownum, 3) end, mod(rownum, 7), mod(rownum * 7, 101) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_abc on t_sk (a, b, c);
create index i_a on t_sk (a);
-- the same a over a descending index
create table t_skd (a int not null, v int);
insert into t_skd select a, v from t_sk where a is not null;
create index i_ad on t_skd (a desc);
update statistics on t_digit, t_sk, t_skd with fullscan;

set trace on;


evaluate 'Case 1: GROUP BY a DESC over an ascending index, ORDER BY another column, covered and not covered; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (a + 100000 * n)) from (select rownum r, a, n from (select /*+ parallel(4) */ a, count(*) n from t_sk where a >= 0 group by a desc using index i_abc(+) order by 2, 1) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a + 100000 * n)) from (select /*+ no_parallel_scan */ rownum r, a, n from (select /*+ no_parallel_scan */ a, count(*) n from t_sk where a >= 0 group by a desc using index i_abc(+) order by 2, 1) y) x;
select /*+ recompile */ count(*), sum(n), sum(s), sum(r * (a + 100000 * s)) from (select rownum r, a, n, s from (select /*+ parallel(4) */ a, count(*) n, sum(v) s from t_sk where a >= 0 group by a desc using index i_a(+) order by 3, 1) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(s), sum(r * (a + 100000 * s)) from (select /*+ no_parallel_scan */ rownum r, a, n, s from (select /*+ no_parallel_scan */ a, count(*) n, sum(v) s from t_sk where a >= 0 group by a desc using index i_a(+) order by 3, 1) y) x;


evaluate 'Case 2: GROUP BY a DESC over an ascending index with DISTINCT; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n) from (select /*+ parallel(4) */ distinct count(*) n from t_sk where a >= 0 group by a desc using index i_abc(+)) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n) from (select /*+ no_parallel_scan */ distinct count(*) n from t_sk where a >= 0 group by a desc using index i_abc(+)) x;


evaluate 'Case 3: GROUP BY a ASC over a descending index, ORDER BY another column; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (a + 100000 * s)) from (select rownum r, a, n, s from (select /*+ parallel(4) */ a, count(*) n, sum(v) s from t_skd where a >= 0 group by a using index i_ad(+) order by 3, 1) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a + 100000 * s)) from (select /*+ no_parallel_scan */ rownum r, a, n, s from (select /*+ no_parallel_scan */ a, count(*) n, sum(v) s from t_skd where a >= 0 group by a using index i_ad(+) order by 3, 1) y) x;


evaluate 'Case 4: GROUP BY a DESC, b DESC, c DESC WITH ROLLUP over an ascending index, ORDER BY a, b, c; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(s), sum(r * (nvl(a, -1) * 100 + nvl(b, -1) * 10 + nvl(c, -1))) from (select rownum r, a, b, c, n, s from (select /*+ parallel(4) */ a, b, c, count(*) n, sum(v) s from t_sk where a >= 0 group by a desc, b desc, c desc with rollup using index i_abc(+) order by a, b, c, 4) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(s), sum(r * (nvl(a, -1) * 100 + nvl(b, -1) * 10 + nvl(c, -1))) from (select /*+ no_parallel_scan */ rownum r, a, b, c, n, s from (select /*+ no_parallel_scan */ a, b, c, count(*) n, sum(v) s from t_sk where a >= 0 group by a desc, b desc, c desc with rollup using index i_abc(+) order by a, b, c, 4) y) x;


evaluate 'Case 5: GROUP BY a ASC over an ascending index, ORDER BY another column, read forwards as before; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (a + 100000 * n)) from (select rownum r, a, n from (select /*+ parallel(4) */ a, count(*) n from t_sk where a >= 0 group by a using index i_abc(+) order by 2, 1) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a + 100000 * n)) from (select /*+ no_parallel_scan */ rownum r, a, n from (select /*+ no_parallel_scan */ a, count(*) n from t_sk where a >= 0 group by a using index i_abc(+) order by 2, 1) y) x;

set trace off;

drop table t_digit, t_sk, t_skd;
