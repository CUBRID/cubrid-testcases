/**
 *  This test case verifies CBRD-27299: a Java FUNCTION declared PARALLEL_ENABLE cannot open the
 *  server-side connection, serially or in parallel workers, and a Java exception it catches
 *  only changes its own return value.
 *
 *  The fix refuses jdbc:default:connection for every call of a declared function, so a worker
 *  without the caller's connection never tries it. The Java methods below come from the CTP
 *  SpTest classes and all catch the refusal: SpTest8.SP catches Exception and returns NULL,
 *  SpTest8.SP3 catches SQLException and returns 0. An undeclared function over the same method
 *  still reads the database. Before the fix every PARALLEL_ENABLE declaration was refused.
 *
 *  Each declared function is paired with an undeclared twin over the same Java method, and
 *  each parallel query with its no_parallel_scan twin (result blocks must match).
 *  The uncaught refusal message needs Java that CTP does not load; the shell
 *  test cbrd_27299_java_limits covers it.
 *
 *  Coverage:
 *    Case 1: caught Exception: declared NULL, undeclared reads db_class
 *    Case 2: caught SQLException: declared 0, undeclared reads the table
 *    Case 3: the same refusals inside parallel workers
 *    Case 4: OID argument passes through a declared function
 *    Case 5: uncaught Java exception, serial and in workers, then the session goes on
 *    Case 6: AUTHID CALLER declared function
 *    Case 7: declared and undeclared calls alternate in one session
 */

drop table if exists t_one, t_big, t_oid;

-- the undeclared SP3 twin returns the first column of the first row: a single row
create table t_one (a int);
insert into t_one values (1);
-- 65536 rows of (int, int): 145 heap pages, 4.5x the 32-page parallel scan threshold of test_mode
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- object argument for the OID case
create table t_oid (id int) dont_reuse_oid;
insert into t_oid values (10);
update statistics on t_one, t_big, t_oid with fullscan;

create function j_sp() return varchar parallel_enable as language java name 'SpTest8.SP() return java.lang.String';
create function j_spu() return varchar as language java name 'SpTest8.SP() return java.lang.String';
create function j_spt(t varchar) return int parallel_enable as language java name 'SpTest8.SP3(java.lang.String) return int';
create function j_sptu(t varchar) return int as language java name 'SpTest8.SP3(java.lang.String) return int';
create function j_jc() return int parallel_enable as language java name 'SpTest.testJdbcCall() return int';
create function j_oida(o object) return object parallel_enable as language java name 'SpTest6.testoid1(cubrid.sql.CUBRIDOID) return cubrid.sql.CUBRIDOID';
create function j_oidb(o object) return string parallel_enable as language java name 'SpTest6.testoid2(cubrid.sql.CUBRIDOID) return java.lang.String';
create function j_pe(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
create function j_bad(x int, s varchar) return int parallel_enable as language java name 'SpTest.testInt(int, java.lang.String) return int';
create function j_caller(x int) return int authid caller parallel_enable as language java name 'SpTest.testInt(int) return int';
create function j_definer(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';


evaluate 'Case 1: caught Exception: declared NULL, undeclared reads db_class';
select j_sp() is null, j_spu() is null;
select j_jc();


evaluate 'Case 2: caught SQLException: declared 0, undeclared reads the table';
select j_spt('t_one'), j_sptu('t_one');


evaluate 'Case 3: the same refusals inside parallel workers';
set trace on;
select /*+ recompile parallel(4) */ sum(j_spt('t_one') + 1), count(j_sp()) from t_big;
show trace;
select /*+ recompile no_parallel_scan */ sum(j_spt('t_one') + 1), count(j_sp()) from t_big;


evaluate 'Case 4: OID argument passes through a declared function';
select j_oida(t) = t, j_oidb(t) from t_oid t;


evaluate 'Case 5: uncaught Java exception, serial and in workers, then the session goes on';
select j_bad(1, '2');
--+ server-message on
select j_bad(1, 'x');
select /*+ recompile parallel(4) */ sum(j_bad(a, 'x')) from t_big;
--+ server-message off
show trace;
select /*+ recompile parallel(4) */ sum(cast(j_pe(a) as bigint)) from t_big;
show trace;
select /*+ recompile no_parallel_scan */ sum(cast(j_pe(a) as bigint)) from t_big;


evaluate 'Case 6: AUTHID CALLER declared function';
select j_caller(1), j_definer(1);
select /*+ recompile parallel(4) */ sum(cast(j_caller(a) as bigint)) from t_big;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ sum(cast(j_caller(a) as bigint)) from t_big;


evaluate 'Case 7: declared and undeclared calls alternate in one session';
select j_sp() is null, j_spu() is null, j_sp() is null, j_spt('t_one'), j_sptu('t_one'), j_spt('t_one');

drop function j_sp, j_spu, j_spt, j_sptu, j_jc, j_oida, j_oidb, j_pe, j_bad, j_caller, j_definer;
drop table t_one, t_big, t_oid;
