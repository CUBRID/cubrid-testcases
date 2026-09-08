/**
 * CBRD-27215 (PR #7658 follow-up): two lazily-evaluated arithmetic nodes in a row -- the second
 * one's left operand is the first one's result.  A NULL left operand must skip BOTH right
 * operands exactly as the interpreter does, so a right operand that would fail (division by
 * zero) on that row never runs; on other rows both must be evaluated.
 */

drop table if exists t1;
create table t1 (id int, ep numeric(15,2), disc numeric(15,2), tax numeric(15,2), z numeric(15,2), a int, b int, c int);
insert into t1 values (1, 100.00, 0.10, 0.05, 2.00, 1, 2, 2);
insert into t1 values (2, NULL, 0.20, 0.06, 0, NULL, 4, 0);
insert into t1 values (3, 300.00, NULL, 0.07, 1.00, 3, NULL, 0);
insert into t1 values (4, 400.00, 0.40, NULL, 4.00, 7, 8, 1);
select id, ep * (1 - disc), ep * (1 - disc) * (1 / z) from t1 where id <> 2 order by id;
select id, ep * (1 - disc) * (1 / z) from t1 where id = 2;
select id, ep * (1 - disc) * (1 / z) from t1 order by id;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 / z)) from t1 where id <> 2;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 / z)) from t1 where id = 2;
select id, a * (b / c) + a * (b / c) * (b / c) from t1 where id in (1, 2) order by id;
select id, a * (b / c) + a * (b / c) * (b / c) from t1 where id = 4;
select id, nvl(a, b / c) + nvl(a, b / c) * 2 from t1 where id in (1, 4) order by id;
select id, nvl(a, b / c) from t1 where id = 2;
select id, nullif(a, b / c) + nullif(a, b / c) * 2 from t1 where id in (1, 2, 4) order by id;
select id, case when c <> 0 then a * (b / c) else 0 end + case when c <> 0 then a * (b / c) else 0 end from t1 order by id;
select id, case when a > 0 then a * (b / c) else -1 end from t1 where id = 2;
drop table t1;
