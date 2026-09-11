/**
 * CBRD-27215 (PR #7658 review): the compiled path must mirror the interpreter's operand fetch order --
 * a NULL left operand skips the right operand of arithmetic and NULLIF, a non-NULL left operand skips
 * the right operand of NVL/IFNULL/COALESCE, and AND/OR short-circuit -- so a right operand that would
 * fail (division by zero) never fails when it is not needed.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
select a + b / c from t1 where id = 1;
select sum(a + b / c) from t1 where id = 1;
select nvl(a, b / c) from t1 where id = 2;
select nullif(a, b / c) from t1 where id = 1;
select case when a > 0 and b / c > 1 then 1 else 0 end from t1 where id = 4;
select if(a is null or b / c > 1, 1, 0) from t1 where id = 1;
select a * (b / c) from t1 where id = 1;
select a - b / c from t1 where id = 1;
select sum(nvl(a, b / c)) from t1 where id = 2;
select coalesce(a, b / c) from t1 where id = 2;
select ifnull(a, b / c) from t1 where id = 2;
select a + (b / c) + 1 from t1 where id = 1;
select a + b / c from t1 where id = 3;
select a + b / c from t1 where id = 2;
select nvl(a, b / c) from t1 where id = 1;
select id, a + (case when c = 0 then b else b / c end) from t1 order by id;
select id, a + nvl(a, b / c) from t1 order by id;
select id, (a + b / c) + (a * b / c) from t1 order by id;
select id, case when a is not null and a + b / c > 0 then 1 else 0 end from t1 order by id;
drop table t1;
