/**
 *  This test case verifies CBRD-27299: a stored function declared PARALLEL_ENABLE no longer
 *  keeps a heap scan serial, while an undeclared one still does.
 *
 *  Before the fix any Java or PL/CSQL function in a predicate made the scan serial, and one in
 *  the select list made the gather row by row. The fix lets declared functions run in the scan
 *  workers (gather buildvalue or mergeable list) and still checks their arguments, so an
 *  undeclared function nested inside a declared one keeps the old behavior.
 *
 *  Every parallel query is followed by its no_parallel_scan twin and the two result blocks
 *  must match. The trace line "(parallel workers: ?, ... gather: ...)" under SCAN proves the
 *  path; CTP masks digits, so worker counts and FUNC calls are checked by the shell test
 *  cbrd_27299_func_stats. f_jp and f_jn call the same Java method, f_pp and f_pn have the
 *  same PL/CSQL body; only the declaration differs. Undeclared calls are kept under 1000
 *  per statement (a > 65000): each one sends rights to the broker.
 *
 *  Coverage:
 *    Case 1:  declared Java function in WHERE, gather buildvalue
 *    Case 2:  declared PL/CSQL function as the aggregate argument
 *    Case 3:  declared function in the select list, gather mergeable list
 *    Case 4:  two declared functions in one predicate, and nested
 *    Case 5:  declared over undeclared and undeclared over declared stay serial
 *    Case 6:  undeclared in the select list with declared in WHERE, row by row
 *    Case 7:  undeclared Java and PL/CSQL functions in WHERE stay serial
 *    Case 8:  undeclared function as the aggregate argument, row by row
 *    Case 9:  hints: parallel(0) is serial, no hint is parallel
 *    Case 10: partitioned table, the scan reopens per partition
 *    Case 11: declared function in a correlated scalar subquery of the scan
 *    Case 12: declared function nested 15 deep in the workers
 */

drop table if exists t_big, t_small, t_part;

-- 65536 rows of (int, int): 145 heap pages, 4.5x the 32-page parallel scan threshold of test_mode
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- three rows for the correlated subquery
create table t_small (a int primary key, b int);
insert into t_small values (1, 1), (2, 2), (3, 3);
-- 131072 rows in 2 hash partitions: about 126 heap pages each, 3.9x the threshold
create table t_part (a int, b int) partition by hash (a) partitions 2;
insert into t_part select a, b from t_big;
insert into t_part select a + 65536, b from t_big;
update statistics on t_big, t_small, t_part with fullscan;

create function f_jp(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
create function f_jn(x int) return int as language java name 'SpTest.testInt(int) return int';
create function f_pp(n int) return int parallel_enable as begin return n + 1; end;
create function f_pn(n int) return int as begin return n + 1; end;

set trace on;


evaluate 'Case 1: declared Java function in WHERE, gather buildvalue; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*) from t_big where f_jp(a) > 3;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where f_jp(a) > 3;


evaluate 'Case 2: declared PL/CSQL function as the aggregate argument; result = no_parallel_scan';
select /*+ recompile parallel(4) */ sum(cast(f_pp(a) as bigint)), max(f_pp(b)) from t_big;
show trace;
select /*+ recompile no_parallel_scan */ sum(cast(f_pp(a) as bigint)), max(f_pp(b)) from t_big;


evaluate 'Case 3: declared function in the select list, gather mergeable list; result = no_parallel_scan';
select /*+ recompile parallel(4) */ f_jp(a), f_pp(b) from t_big where b > 65532 order by 1;
show trace;
select /*+ recompile no_parallel_scan */ f_jp(a), f_pp(b) from t_big where b > 65532 order by 1;


evaluate 'Case 4: two declared functions in one predicate, and nested; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*) from t_big where f_jp(a) + f_pp(b) > 7;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where f_jp(a) + f_pp(b) > 7;
select /*+ recompile parallel(4) */ count(*) from t_big where f_jp(f_pp(a)) > 5;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where f_jp(f_pp(a)) > 5;


evaluate 'Case 5: declared over undeclared and undeclared over declared stay serial; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*) from t_big where a > 65000 and f_jp(f_jn(a)) > 65006;
show trace;
select /*+ recompile parallel(4) */ count(*) from t_big where a > 65000 and f_jn(f_jp(a)) > 65006;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where a > 65000 and f_jn(f_jp(a)) > 65006;


evaluate 'Case 6: undeclared in the select list with declared in WHERE, row by row; result = no_parallel_scan';
select /*+ recompile parallel(4) */ f_jn(a) from t_big where f_jp(b) > 65533 order by 1;
show trace;
select /*+ recompile no_parallel_scan */ f_jn(a) from t_big where f_jp(b) > 65533 order by 1;


evaluate 'Case 7: undeclared Java and PL/CSQL functions in WHERE stay serial; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*) from t_big where a > 65000 and f_jn(a) > 65008;
show trace;
select /*+ recompile parallel(4) */ count(*) from t_big where a > 65000 and f_pn(a) > 65009;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where a > 65000 and f_pn(a) > 65009;


evaluate 'Case 8: undeclared function as the aggregate argument, row by row; result = no_parallel_scan';
select /*+ recompile parallel(4) */ sum(cast(f_jn(a) as bigint)) from t_big where a > 65000;
show trace;
select /*+ recompile no_parallel_scan */ sum(cast(f_jn(a) as bigint)) from t_big where a > 65000;


evaluate 'Case 9: hints: parallel(0) is serial, no hint is parallel; result = no_parallel_scan';
select /*+ recompile parallel(0) */ count(*) from t_big where f_jp(a) > 10;
show trace;
select /*+ recompile */ count(*) from t_big where f_jp(a) > 10;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where f_jp(a) > 10;


evaluate 'Case 10: partitioned table, the scan reopens per partition; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(f_jp(b) as bigint)) from t_part where f_pp(a) > 11;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(f_jp(b) as bigint)) from t_part where f_pp(a) > 11;


evaluate 'Case 11: declared function in a correlated scalar subquery of the scan; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*) from t_big where b > (select min(f_jp(z.b)) from t_small z where z.a = mod(t_big.a, 3) + 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where b > (select min(f_jp(z.b)) from t_small z where z.a = mod(t_big.a, 3) + 1);


evaluate 'Case 12: declared function nested 15 deep in the workers; result = no_parallel_scan';
-- 15 nested calls are the deepest that both the workers and the serial path accept
select /*+ recompile parallel(4) */ count(*), max(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(a)))))))))))))))) from t_big;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ count(*), max(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(f_pp(a)))))))))))))))) from t_big;

drop function f_jp, f_jn, f_pp, f_pn;
drop table t_big, t_small, t_part;
