/**
 * CBRD-27215 (PR #7658 review): SUM over a BIGINT accumulator runs the compiled accumulate kernel
 * qdata_acc_kernel_sum_bigint () (;trace shows "agg[0]: sum_bigint").  Crossing DB_BIGINT_MAX /
 * DB_BIGINT_MIN must raise the interpreter's overflow error (-458, "Overflow occurred in addition
 * context.") in an optimized build: the kernel adds and tests the overflow flag in one step
 * (OR_ADD_OVERFLOW) instead of wrapping first, which is undefined behavior for signed operands.
 * Every statement goes through qdata_add_bigint () on develop, where the answers are generated.
 */

drop table if exists t_sum_ovf;
create table t_sum_ovf (id int, g int, b bigint);
insert into t_sum_ovf values (1, 1, 9223372036854775807);
insert into t_sum_ovf values (2, 1, 1);
insert into t_sum_ovf values (3, 2, -9223372036854775807 - 1);
insert into t_sum_ovf values (4, 2, -1);
insert into t_sum_ovf values (5, 3, 9223372036854775807);
insert into t_sum_ovf values (6, 3, -9223372036854775807 - 1);
insert into t_sum_ovf values (7, 4, NULL);
insert into t_sum_ovf values (8, 4, 5000000000);
insert into t_sum_ovf values (9, 5, 9223372036854775807);
insert into t_sum_ovf values (10, 5, 0);

-- DB_BIGINT_MAX + 1 (either accumulation order): develop Error:-458
select sum(b) from t_sum_ovf where g = 1;
-- DB_BIGINT_MIN + (-1): develop Error:-458
select sum(b) from t_sum_ovf where g = 2;
-- MAX + MIN = -1: no overflow in either order -> -1
select sum(b) from t_sum_ovf where g = 3;
-- NULL is skipped, the single non-NULL row takes the first-row copy path -> 5000000000
select sum(b) from t_sum_ovf where g = 4;
-- MAX + 0 lands exactly on the boundary: not an overflow -> 9223372036854775807
select sum(b) from t_sum_ovf where g = 5;
-- hash GROUP BY and sorted GROUP BY over the non-overflowing groups -> (3,-1) (4,5000000000) (5,MAX)
select g, sum(b) from t_sum_ovf where g in (3, 4, 5) group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(b) from t_sum_ovf where g in (3, 4, 5) group by g order by g;
-- an overflowing group fails the whole statement on both paths: Error:-458
select g, sum(b) from t_sum_ovf where g in (1, 3) group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(b) from t_sum_ovf where g in (2, 3) group by g order by g;
-- a computed operand still resolves the BIGINT accumulator kernel: Error:-458 / Error:-458
select sum(b + 0) from t_sum_ovf where g = 1;
select sum(b * 1) from t_sum_ovf where g = 2;
drop table t_sum_ovf;
