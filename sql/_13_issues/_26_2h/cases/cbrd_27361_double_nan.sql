/**
 *  This test case verifies CBRD-27361: the page batch compares two DOUBLE columns of a row as the row path's
 *  fast kernel does, with the operator itself, so a NaN on either side satisfies only <>.
 *
 *  Coverage:
 *    Case 1: =, <>, <, <=, > and >= between two DOUBLE columns, a NaN on the left, on the right, on both
 *    Case 2: the same under NO_PARALLEL_SCAN
 */

drop table if exists t_nan;
create table t_nan (id int, a double, b double);
insert into t_nan values (1, cast('nan' as double), 1.0), (2, 1.0, cast('nan' as double)),
  (3, cast('nan' as double), cast('nan' as double)), (4, 1.0, 1.0), (5, 2.0, 1.0);

evaluate 'Case 1: two DOUBLE columns, a NaN on either side';
select count(*), sum(id) from t_nan where a = b;
select count(*), sum(id) from t_nan where a <> b;
select count(*), sum(id) from t_nan where a < b;
select count(*), sum(id) from t_nan where a <= b;
select count(*), sum(id) from t_nan where a > b;
select count(*), sum(id) from t_nan where a >= b;

evaluate 'Case 2: the serial scan agrees';
select /*+ NO_PARALLEL_SCAN */ count(*), sum(id) from t_nan where a = b;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(id) from t_nan where a <> b;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(id) from t_nan where a <= b;

drop table t_nan;
