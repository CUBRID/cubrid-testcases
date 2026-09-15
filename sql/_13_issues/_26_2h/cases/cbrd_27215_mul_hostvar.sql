/**
 * CBRD-27215 (PR #7658 review): SUM(numeric * ?) with an INTEGER/BIGINT/SHORT host variable must
 * coerce the integer side to NUMERIC and multiply with the plain numeric family, as the interpreter
 * does (qdata_multiply_numeric ()) -- not report an overflow, and with the same result scale.
 * A NUMERIC bind keeps the pure NUMERIC x NUMERIC (float) path; rebinding another type recompiles.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');

$int, $2
select sum(n1 * ?) from t1;
$bigint, $2
select sum(n1 * ?) from t1;
$short, $2
select sum(n1 * ?) from t1;
$numeric, $2.00
select sum(n1 * ?) from t1;
$int, $3
select sum(n1 * ?) from t1;
$int, $2
select sum(? * n1) from t1;
$bigint, $2
select sum(? * n1) from t1;
$int, $2, $int, $2, $int, $2, $int, $2
select sum(n1 * ?), sum(n1 + ?), sum(n1 - ?), sum(n1 / ?) from t1;
$numeric, $2.5, $numeric, $2.5, $numeric, $2.5, $numeric, $2.5
select sum(n1 * ?), sum(n1 + ?), sum(n1 - ?), sum(n1 / ?) from t1;
$int, $2
select id, n1 * ? from t1 order by id;
$bigint, $2
select id, n1 * ? from t1 order by id;
select sum(n1 * bi), sum(n1 * a), sum(n1 * 2), sum(bi * n1), sum(n1 * 2.5) from t1;
drop table t1;
