/**
 *  This test case verifies CBRD-27361: SUM and AVG over the same value share one accumulator, and the page batch
 *  plan of a block is kept between the runs of the block. A correlated scalar subquery runs its block once per
 *  outer row: every run must link the shared accumulators again as the kept plan expects, and give the row path's
 *  answers (before the fix the second outer row failed with "Invalid XASL tree node content").
 *
 *  Coverage:
 *    Case 1: SUM and AVG of one expression in a correlated scalar subquery -- INT, DOUBLE and NUMERIC operands
 *    Case 2: operands written in another order (b + a), a correlated filter, and a GROUP BY inside the subquery
 */

drop table if exists t_co;
drop table if exists t_ci;
create table t_co (k int);
insert into t_co values (1), (2), (3);
create table t_ci (n int, d double, m numeric(10,2));
insert into t_ci values (1, 1, 1.5), (2, 2, 2.5), (3, 3, 3.5);

evaluate 'Case 1: SUM and AVG of one expression, the subquery run once per outer row';
select o.k, (select sum (i.n * 2) + avg (i.n * 2) + o.k from t_ci i) as v from t_co o order by o.k;
select o.k, (select sum (i.d * 2) + avg (i.d * 2) + o.k from t_ci i) as v from t_co o order by o.k;
select o.k, (select sum (i.m * 2) + avg (i.m * 2) + o.k from t_ci i) as v from t_co o order by o.k;

evaluate 'Case 2: operands in another order, a correlated filter, a GROUP BY in the subquery';
select o.k, (select sum (i.n + i.d) + avg (i.d + i.n) from t_ci i where i.n <= o.k) as v from t_co o order by o.k;
select o.k, (select sum (i.n * 2) + avg (i.n * 2) from t_ci i where i.n >= o.k) as v from t_co o order by o.k;
select o.k, (select count (*) + sum (i.n * 3) + avg (i.n * 3) from t_ci i group by i.n having i.n = o.k) as v from t_co o order by o.k;

drop table t_co, t_ci;
