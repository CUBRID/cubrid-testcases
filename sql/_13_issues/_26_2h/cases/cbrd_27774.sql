/**
 *  CBRD-27774: MEDIAN, PERCENTILE_CONT, PERCENTILE_DISC and NTH_VALUE ... IGNORE NULLS over a partition
 *  that holds NULLs must give the same result when the analytic sort is skipped by the index order.
 *
 *  When an index on the PARTITION BY column delivers the rows in partition order, the sort of the
 *  analytic function is skipped and the row count and the non-NULL row count of each partition are
 *  recorded while the rows are read. That path recorded the row count as the non-NULL row count, so
 *  these functions looked for more non-NULL values than the partition has: MEDIAN of NULL, 1, 2, 3
 *  gave 2.5 instead of 2, and a partition with only NULLs made the query fail (an assertion on a
 *  debug server). The counts of the last partition are recorded at a different point from the
 *  others, so t1 has two partitions.
 *
 *  Each partition of t1 holds 2 NULLs and 3 values. Every function runs over all the rows (some
 *  NULLs), then over the NULLs only (c3 IS NULL). NTH_VALUE asks for a value that the partition does
 *  not have but the row count allows: the 4th value of 5 rows, then the 2nd value of 2 rows.
 *
 *  Coverage:
 *  1    MEDIAN
 *  2    PERCENTILE_CONT
 *  3    PERCENTILE_DISC
 *  4    NTH_VALUE ... IGNORE NULLS
 */

drop table if exists t1;

create table t1 (c1 int primary key, c2 int, c3 int);
create index t1_idx on t1 (c2, c3);
insert into t1 values (1, 1, null), (2, 1, null), (3, 1, 1), (4, 1, 2), (5, 1, 3), (6, 2, null), (7, 2, null), (8, 2, 4), (9, 2, 5), (10, 2, 6);


evaluate 'Case 1: MEDIAN over partitions with some NULLs, then with only NULLs';
select /*+ recompile */ c2, median(c3) over (partition by c2) as m from t1 where c2 > 0;
select /*+ recompile */ c2, median(c3) over (partition by c2) as m from t1 where c2 > 0 and c3 is null;


evaluate 'Case 2: PERCENTILE_CONT over partitions with some NULLs, then with only NULLs';
select /*+ recompile */ c2, percentile_cont(0.5) within group (order by c3) over (partition by c2) as pc from t1 where c2 > 0;
select /*+ recompile */ c2, percentile_cont(0.5) within group (order by c3) over (partition by c2) as pc from t1 where c2 > 0 and c3 is null;


evaluate 'Case 3: PERCENTILE_DISC over partitions with some NULLs, then with only NULLs';
select /*+ recompile */ c2, percentile_disc(0.5) within group (order by c3) over (partition by c2) as pd from t1 where c2 > 0;
select /*+ recompile */ c2, percentile_disc(0.5) within group (order by c3) over (partition by c2) as pd from t1 where c2 > 0 and c3 is null;


evaluate 'Case 4: NTH_VALUE ... IGNORE NULLS over partitions with some NULLs, then with only NULLs';
select /*+ recompile */ c2, nth_value(c3, 4) ignore nulls over (partition by c2) as nv from t1 where c2 > 0;
select /*+ recompile */ c2, nth_value(c3, 2) ignore nulls over (partition by c2) as nv from t1 where c2 > 0 and c3 is null;


drop table t1;
