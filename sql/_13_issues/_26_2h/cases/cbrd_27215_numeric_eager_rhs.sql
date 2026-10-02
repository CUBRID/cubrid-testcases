/**
 * CBRD-27215 (PR #7658 follow-up): a pure NUMERIC +, -, * right-hand side whose integer digits
 * provably fit is evaluated eagerly (it cannot fail), so the shared sub-expression of
 * sum(ep * (1 - disc)) and sum(ep * (1 - disc) * (1 + tax)) compiles once.  The results must
 * stay identical to the interpreter for NULL operands, wide products and mixed literals; a
 * right-hand side that can fail (division) must still be skipped for a NULL left operand.
 */

drop table if exists t1;
create table t1 (id int, ep numeric(15,2), disc numeric(15,2), tax numeric(15,2), big numeric(38,0), z numeric(15,2));
insert into t1 values (1, 100.00, 0.10, 0.05, 99999999999999999999999999999999999999, 0);
insert into t1 values (2, NULL, 0.20, 0.06, 99999999999999999999999999999999999999, 0);
insert into t1 values (3, 300.00, NULL, 0.07, NULL, 0);
insert into t1 values (4, 400.00, 0.40, NULL, -99999999999999999999999999999999999999, 0);
select id, ep * (1 - disc), ep * (1 - disc) * (1 + tax) from t1 order by id;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 + tax)), avg(ep * (1 - disc)) from t1;
select id, ep * (1 - disc) from t1 where ep is null;
select id, ep + big * big, ep - big * big from t1 order by id;
select id, big * big * big from t1 order by id;
select id, ep + (1 - disc) / z from t1 where id = 2;
select id, ep * (1.5 - disc) + (2 * tax) from t1 order by id;
select id, (ep - 0.5) * (disc + 1.25) - (tax * 3) from t1 order by id;
select id, ep * (1 - disc) from t1 where ep * (1 - disc) > 80 order by id;
select sum(ep * (1 - disc)) from t1 group by id > 2 order by 1;
drop table t1;
