/**
 *  This test case verifies CBRD-27509: a parallel GROUP BY must aggregate with the
 *  domains its workers resolved from the rows they read.
 *
 *  The workers of a parallel scan hand the gather the first non-NULL value of each
 *  column, and the gather resolved the aggregate domains again from those values.
 *  They come from different rows, so an operand that is non-NULL on a single row,
 *  CASE WHEN flag = 1 THEN 555 END, is NULL on that mix. The domain stayed unresolved
 *  and was set to NULL. The partial accumulators the workers wrote were then read with
 *  that domain: MAX came back NULL and the later columns of each partial tuple were
 *  misread, COUNT(*) among them. A row aggregated after the gather failed with a
 *  coercion to the NULL domain, and an optdebug server stopped on an assertion in
 *  qfile_set_layout ().
 *
 *  The fix (engine PR #8058) hands the domains a worker resolved to the gather, as the
 *  parallel BUILDVALUE merge already did. A worker resolves them from every row until
 *  they are resolved, also when it does not hash aggregate the row, and a partial list
 *  column that a worker left unresolved gets the resolved domain before the lists are
 *  chained.
 *
 *  Every parallel query is followed by the same query with parallel(0), which runs it
 *  serially, and the two result blocks must match. CTP runs with test_mode=yes, which
 *  masks volatile trace values to '?'. The traces show the parallel scan with its
 *  mergeable list gather and the GROUPBY, hash: partial or, under NO_HASH_AGGREGATE,
 *  hash: false.
 *
 *  Coverage:
 *    Case 1:  the reported query, hash aggregation
 *    Case 2:  the same query with NO_HASH_AGGREGATE, sort aggregation after the gather
 *    Case 3:  MIN, SUM, AVG, COUNT and a string MAX over the same operand, hash and sort
 *    Case 4:  unique group key, every worker gives up hash aggregation before the row
 *    Case 5:  range partitioned table, only the second partition resolves the domain,
 *             so its partial lists are chained after those of the first
 */

drop table if exists t, tk, tp, n10, n2;

create table n10 (v int);
insert into n10 values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create table n2 (v int);
insert into n2 values (0), (1);

-- the reported data: 200000 rows, 20000 in each grp 0..9, flag = 1 on one row of grp 0.
-- Each table below is large enough to be scanned in parallel under test_mode (parallel_scan_page_threshold 32).
create table t (grp int, flag int);
insert into t
select lo.v, case when lo.v = 0 and d1.v = 9 and d2.v = 9 and d3.v = 9 and d4.v = 9 and hi.v = 1 then 1 else 0 end
  from n2 hi, n10 d4, n10 d3, n10 d2, n10 d1, n10 lo;

-- the same rows with a unique key k, flag = 1 on k = 199990
create table tk (k int, flag int);
insert into tk
select hi.v * 100000 + d4.v * 10000 + d3.v * 1000 + d2.v * 100 + d1.v * 10 + lo.v,
       case when lo.v = 0 and d1.v = 9 and d2.v = 9 and d3.v = 9 and d4.v = 9 and hi.v = 1 then 1 else 0 end
  from n2 hi, n10 d4, n10 d3, n10 d2, n10 d1, n10 lo;

-- range partitioned on grp, flag = 1 on one row of grp 9, which is in the second partition
create table tp (grp int, flag int)
  partition by range (grp) (partition p0 values less than (5), partition p1 values less than maxvalue);
insert into tp
select lo.v, case when lo.v = 9 and d1.v = 9 and d2.v = 9 and d3.v = 9 and d4.v = 9 and hi.v = 1 then 1 else 0 end
  from n2 hi, n10 d4, n10 d3, n10 d2, n10 d1, n10 lo;

update statistics on t, tk, tp with fullscan;

set trace on;


evaluate 'Case 1: the reported query, parallel hash aggregation; result = parallel(0)';
select /*+ recompile */ grp, count(*), max(case when flag = 1 then 555 else null end) as mx from t group by grp order by grp;
show trace;
select /*+ recompile parallel(0) */ grp, count(*), max(case when flag = 1 then 555 else null end) as mx from t group by grp order by grp;


evaluate 'Case 2: NO_HASH_AGGREGATE, sort aggregation after the gather; result = parallel(0)';
-- without a hash table the workers only pass the rows on, and the gather aggregates them with the domains
-- the workers resolved
select /*+ recompile NO_HASH_AGGREGATE */ grp, count(*), max(case when flag = 1 then 555 else null end) as mx from t group by grp order by grp;
show trace;
select /*+ recompile NO_HASH_AGGREGATE parallel(0) */ grp, count(*), max(case when flag = 1 then 555 else null end) as mx from t group by grp order by grp;


evaluate 'Case 3: MIN, SUM, AVG, COUNT and a string MAX over the same operand, hash and sort; result = parallel(0)';
select /*+ recompile */ grp, count(*), min(case when flag = 1 then 555 end) as mn, sum(case when flag = 1 then 555 end) as sm, avg(case when flag = 1 then 555 end) as av, count(case when flag = 1 then 555 end) as cn, max(case when flag = 1 then 'abc' end) as sx from t group by grp order by grp;
select /*+ recompile parallel(0) */ grp, count(*), min(case when flag = 1 then 555 end) as mn, sum(case when flag = 1 then 555 end) as sm, avg(case when flag = 1 then 555 end) as av, count(case when flag = 1 then 555 end) as cn, max(case when flag = 1 then 'abc' end) as sx from t group by grp order by grp;
select /*+ recompile NO_HASH_AGGREGATE */ grp, count(*), min(case when flag = 1 then 555 end) as mn, sum(case when flag = 1 then 555 end) as sm, avg(case when flag = 1 then 555 end) as av, count(case when flag = 1 then 555 end) as cn, max(case when flag = 1 then 'abc' end) as sx from t group by grp order by grp;
select /*+ recompile NO_HASH_AGGREGATE parallel(0) */ grp, count(*), min(case when flag = 1 then 555 end) as mn, sum(case when flag = 1 then 555 end) as sm, avg(case when flag = 1 then 555 end) as av, count(case when flag = 1 then 555 end) as cn, max(case when flag = 1 then 'abc' end) as sx from t group by grp order by grp;


evaluate 'Case 4: unique group key, the workers give up hash aggregation before the row; result = parallel(0)';
-- every row is its own group, so a worker gives up hash aggregation after its first 2000 rows, well before
-- the flag = 1 row, and passes the rest on to be aggregated after the gather
select /*+ recompile */ k, max(case when flag = 1 then 555 end) as mx from tk group by k having max(case when flag = 1 then 555 end) is not null;
show trace;
select /*+ recompile parallel(0) */ k, max(case when flag = 1 then 555 end) as mx from tk group by k having max(case when flag = 1 then 555 end) is not null;


evaluate 'Case 5: range partitioned table, only the second partition resolves the domain; result = parallel(0)';
-- each partition is scanned and gathered in turn, so the partial lists of the second partition are chained
-- after those of the first, whose accumulator columns are all NULL
select /*+ recompile */ grp, count(*), max(case when flag = 1 then 555 end) as mx from tp group by grp order by grp;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ grp, count(*), max(case when flag = 1 then 555 end) as mx from tp group by grp order by grp;


drop table t, tk, tp, n10, n2;
