/**
 * CBRD-27215 (PR #7658 review): typed comparison leaves, EXTRACT and NUMERIC kernels verify the runtime
 * value type and fall back when the domain and the value disagree (recursive CTE type drift).
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
with recursive r(n, m) as (select 1, 1 from db_root union all select n + 1, m * 2147483647 from r where n < 3) select n, m, case when m > 100 then 'big' else 'small' end, extract(year from date'2024-01-01') from r;
with recursive r(n) as (select cast(1 as bigint) from db_root union all select n * 1000000007 from r where n < 1000000000000000) select n, n = 1000000007, n > 5 from r;
select id, extract(year from dt), extract(month from dt), extract(day from dt) from t1 order by id;
select sum(case when bi > 5500000000 then 1 else 0 end), sum(case when d > 2.0 then 1 else 0 end) from t1;
drop table t1;
