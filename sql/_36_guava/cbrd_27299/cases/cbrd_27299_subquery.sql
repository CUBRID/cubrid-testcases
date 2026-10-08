/**
 *  This test case verifies CBRD-27299: parallel subquery execution with stored functions. A
 *  declared function runs inside a job, and an undeclared one now blocks only its own block.
 *
 *  Before the fix any stored function made every uncorrelated subquery run serially, yet one in
 *  an aggregate argument was missed and its block could still go to a worker. The fix keeps
 *  only the block holding an undeclared function on the main thread, lets its siblings run as
 *  jobs, and also checks aggregate arguments, HAVING and grouped aggregates.
 *
 *  The line "(parallel workers: ...)" under SUBQUERY (uncorrelated) is printed when the
 *  statement runs its derived tables as parallel jobs. Every statement is followed by its
 *  no_parallel_subquery twin and the result blocks must match. The pre-fix server aborted on
 *  an undeclared function in an aggregate of a later derived table (Cases 3, 11 to 13).
 *  Undeclared calls stay under 1000 per statement: each one sends rights to the broker.
 *
 *  Coverage:
 *    Case 1:  declared function in a derived table, a cached plan run twice, then recompiled
 *    Case 2:  undeclared function in the first of three derived tables
 *    Case 3:  one clean block left (2 of 3 dirty, 1 of 2 dirty): no parallel jobs
 *    Case 4:  undeclared function in a derived table nested in another
 *    Case 5:  declared and undeclared in one block, declared over undeclared
 *    Case 6:  undeclared function in the root WHERE and select list
 *    Case 7:  undeclared PL/CSQL function with static SQL in an aggregate argument
 *    Case 8:  undeclared function only in HAVING of a derived table
 *    Case 9:  undeclared function in a grouped aggregate below a derived table
 *    Case 10: analytic PARTITION BY: undeclared in the last of three derived tables, declared
 *    Case 11: undeclared function in the middle derived table
 *    Case 12: undeclared function in the last derived table
 *    Case 13: undeclared static-SQL function in a later derived table
 */

drop table if exists t_big, t_mid, t_code;

-- 65536 rows of (int, int): 145 heap pages, 4.5x the 32-page parallel scan threshold of test_mode
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- 50000 rows; b differs from a so the derived tables return different values
create table t_mid (a int, b int);
insert into t_mid select a, case when mod(a, 1000) = 0 then a - 5 else a + 5 end from t_big where a <= 50000;
-- one row per value 1 to 5, read by the static SQL of f_sqlc
create table t_code (c int);
insert into t_code values (1), (2), (3), (4), (5);
update statistics on t_big, t_mid, t_code with fullscan;

create function f_jp(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
create function f_jn(x int) return int as language java name 'SpTest.testInt(int) return int';
create function f_sqlc(x int) return int as n int; begin select count(*) into n from t_code where c = mod(x - 1, 5) + 1; return x + n; end;

set trace on;


evaluate 'Case 1: declared function in a derived table, a cached plan run twice, then recompiled; result = no_parallel_subquery';
-- no recompile on the first two: the second reuses the cached plan whose function signature the
-- jobs of the first execution shared
select /*+ parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
select /*+ parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 2: undeclared function in the first of three derived tables; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 3: one clean block left (2 of 3 dirty, 1 of 2 dirty): no parallel jobs; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(f_jn(b)) m from t_mid where a > 49500) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(f_jn(b)) m from t_mid where a > 49500) f;
select /*+ recompile parallel(4) */ d.s, e.n from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e;


evaluate 'Case 4: undeclared function in a derived table nested in another; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select x.s from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) x) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select x.s from (select sum(cast(f_jn(a) as bigint)) s from t_big where a > 65000) x) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 5: declared and undeclared in one block, declared over undeclared; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) + sum(cast(f_jn(b) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_jp(a) as bigint)) + sum(cast(f_jn(b) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_jp(f_jn(a)) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_jp(f_jn(a)) as bigint)) s from t_big where a > 65000) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 6: undeclared function in the root WHERE and select list; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e where f_jn(e.n mod 7) > 0;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e where f_jn(e.n mod 7) > 0;
select /*+ recompile parallel(4) */ f_jn(d.s mod 1000), e.n from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e;
show trace;
select /*+ recompile no_parallel_subquery */ f_jn(d.s mod 1000), e.n from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e;


evaluate 'Case 7: undeclared PL/CSQL function with static SQL in an aggregate argument; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(f_sqlc(a) as bigint)) s from t_big where a > 65400) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(f_sqlc(a) as bigint)) s from t_big where a > 65400) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 8: undeclared function only in HAVING of a derived table; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big having f_jn(1) > 0) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big having f_jn(1) > 0) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 9: undeclared function in a grouped aggregate below a derived table; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, d.g, e.n, f.m from (select sum(z.v) s, count(*) g from (select b mod 7 k, sum(cast(f_jn(a) as bigint)) v from t_big where a > 65000 group by b mod 7) z) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, d.g, e.n, f.m from (select sum(z.v) s, count(*) g from (select b mod 7 k, sum(cast(f_jn(a) as bigint)) v from t_big where a > 65000 group by b mod 7) z) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(b) m from t_mid) f;


evaluate 'Case 10: analytic PARTITION BY, undeclared in the last of three derived tables, declared; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.r, f.c from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(r) r, count(*) c from (select rank() over (partition by f_jn(b) mod 5 order by a) r from t_big where a <= 300) z) f;
select /*+ recompile parallel(4) */ d.s, e.n, f.r, f.c from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(r) r, count(*) c from (select rank() over (partition by f_jn(b) mod 5 order by a) r from t_big where a <= 300) z) f;
select /*+ recompile parallel(4) */ d.s, e.n, f.r, f.c from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(r) r, count(*) c from (select rank() over (partition by f_jn(b) mod 5 order by a) r from t_big where a <= 300) z) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.r, f.c from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(r) r, count(*) c from (select rank() over (partition by f_jn(b) mod 5 order by a) r from t_big where a <= 300) z) f;
select /*+ recompile parallel(4) */ d.s, e.n from (select max(r) s from (select rank() over (partition by f_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d, (select sum(cast(b as bigint)) n from t_mid) e;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n from (select max(r) s from (select rank() over (partition by f_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d, (select sum(cast(b as bigint)) n from t_mid) e;


evaluate 'Case 11: undeclared function in the middle derived table; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(f_jn(b) as bigint)) n from t_mid where a > 49500) e, (select max(b) m from t_mid) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(f_jn(b) as bigint)) n from t_mid where a > 49500) e, (select max(b) m from t_mid) f;


evaluate 'Case 12: undeclared function in the last derived table; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(f_jn(b)) m from t_mid where a > 49500) f;
show trace;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(b as bigint)) n from t_mid) e, (select max(f_jn(b)) m from t_mid where a > 49500) f;


evaluate 'Case 13: undeclared static-SQL function in a later derived table; result = no_parallel_subquery';
select /*+ recompile parallel(4) */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(f_sqlc(b) as bigint)) n from t_mid where a > 49900) e, (select max(b) m from t_mid) f;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_subquery */ d.s, e.n, f.m from (select sum(cast(a as bigint)) s from t_big) d, (select sum(cast(f_sqlc(b) as bigint)) n from t_mid where a > 49900) e, (select max(b) m from t_mid) f;

drop function f_jp, f_jn, f_sqlc;
drop table t_big, t_mid, t_code;
