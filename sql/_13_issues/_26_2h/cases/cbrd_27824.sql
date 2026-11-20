/**
 *  CBRD-27824: NTH_VALUE (expr, n) FROM LAST must return the n-th value from the end of the partition.
 *
 *  The position of the n-th value from the end was computed one row past it, so FROM LAST returned the
 *  (n - 1)-th value from the end and NULL for n = 1. IGNORE NULLS counts the same way over the non-NULL
 *  values only, so it was wrong the same way. Partition 1 of t1 has 5 rows (3 non-NULL c3) and
 *  partition 2 has 3 rows (1 non-NULL c3), so one n is the first value of one partition and beyond the
 *  other.
 *
 *  Coverage:
 *  1    FROM LAST over all rows of the partition: n = 1, 2, the row count, beyond it
 *  2    FROM LAST IGNORE NULLS: n counts the non-NULL values from the last one, past the NULL rows
 */

drop table if exists t1;

create table t1 (c1 int, c2 int, c3 int);
insert into t1 values (1, 10, 1), (1, 20, null), (1, 30, 2), (1, 40, 3), (1, 50, null), (2, 60, 4), (2, 70, null), (2, 80, null);


evaluate 'Case 1: FROM LAST counts from the last row of the partition: n = 1, 2, 3, 5 over 5 rows and over 3 rows';
select /*+ recompile */ c1, c2, nth_value(c2, 1) from last over (partition by c1) as l1, nth_value(c2, 2) from last over (partition by c1) as l2, nth_value(c2, 3) from last over (partition by c1) as l3, nth_value(c2, 5) from last over (partition by c1) as l5 from t1 order by c1, c2;


evaluate 'Case 2: FROM LAST IGNORE NULLS counts from the last non-NULL value: n = 1, 2, 3 over 3 and over 1 non-NULL values';
select /*+ recompile */ c1, c2, c3, nth_value(c3, 1) from last ignore nulls over (partition by c1) as l1, nth_value(c3, 2) from last ignore nulls over (partition by c1) as l2, nth_value(c3, 3) from last ignore nulls over (partition by c1) as l3 from t1 order by c1, c2;


drop table t1;
