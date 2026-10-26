/**
 *  This test case verifies CBRD-27579: a stored procedure / function invoked inside a SQL statement
 *  may not end the transaction, run DDL or run DML, whatever the table. Reading is allowed.
 *
 *  This file covers a function invoked by SELECT, a subquery, DO and a view.
 *
 *  Covered by other test cases, not repeated here:
 *    CALL alone (COMMIT / ROLLBACK / DML / DDL allowed):
 *      sql/_35_fig_cake/plcsql/basic/cases/test_tcl.sql
 *      sql/_05_plcsql/_01_testspec/_04_expression/_07_sql_rowcount/_01_basic/cases/04_07_01-01_normal_basic_commit.sql (and _rollback, _crud)
 *      sql/_05_plcsql/_01_testspec/_03_statement/_04_execute_immediate
 *    COMMIT in a function invoked by SELECT:  sql/_36_guava/cbrd_27299/cases/cbrd_27299_plcsql.sql (Case 12)
 *    DML in a function invoked by SELECT:     sql/_05_plcsql/_01_testspec/_05_bug_fix/cases/26_recursive_function.sql
 *                                             sql/_13_issues/_25_2h/cases/cbrd_26165.sql
 *
 *  Coverage:
 *    Case 1: ROLLBACK, SAVEPOINT, 2PC (PREPARE TO COMMIT, ATTACH) and DDL in a function invoked by SELECT
 *    Case 2: a function invoked by a subquery or DO
 *    Case 3: a view whose query calls a function
 *    Case 4: INCR () in a function invoked by SELECT, directly or through PREPARE and EXECUTE,
 *            and a name prepared again in a loop runs the new statement
 *    Case 5: nothing was written
 */

--+ server-message on

drop view if exists v_sel;
drop view if exists v_dml;
drop table if exists t;
drop table if exists s;
drop table if exists log_t;
drop table if exists cnt_t;
drop table if exists t_new;

create table t (a int);
insert into t values (1), (2), (3);
create table s (a int);
insert into s values (1);
create table log_t (x int);
create table cnt_t (id int, cnt int);
insert into cnt_t values (1, 0);

create or replace function f_dml (n int) return int as begin insert into log_t values (n); return 1; end;
create or replace function f_sel return int as c int; begin select count (*) into c from t; return c; end;
create or replace function f_rollback return int as begin rollback; return 1; end;
create or replace function f_savepoint return int as begin execute immediate 'savepoint sp1'; return 1; end;
create or replace function f_ddl return int as begin execute immediate 'create table t_new (a int)'; return 1; end;
create or replace function f_prepare_to_commit return int as begin execute immediate 'prepare to commit 77'; return 1; end;
create or replace function f_attach return int as begin execute immediate 'attach 77'; return 1; end;
create or replace function f_incr return int as c int; begin select incr (cnt) into c from cnt_t where id = 1; return c; end;
create or replace function f_incr_execute return int as
begin
  execute immediate 'prepare s_incr from ''select incr (cnt) from cnt_t where id = 1''';
  execute immediate 'execute s_incr';
  return 1;
end;
create or replace function f_reprepare return varchar as x int; r varchar := '';
begin
  for i in 1 .. 2 loop
    if i = 1 then
      execute immediate 'prepare s_loop from ''select 100 from db_root''';
    else
      execute immediate 'prepare s_loop from ''select 200 from db_root''';
    end if;
    execute immediate 'execute s_loop' into x;
    r := r || x || ' ';
  end loop;
  return r;
end;
create or replace function f_reprepare_incr return int as
begin
  for i in 1 .. 2 loop
    if i = 1 then
      execute immediate 'prepare s_loop_incr from ''select 1 from db_root''';
    else
      execute immediate 'prepare s_loop_incr from ''select incr (cnt) from cnt_t where id = 1''';
    end if;
    execute immediate 'execute s_loop_incr';
  end loop;
  return 1;
end;

create view v_sel as select a, f_sel () as c from t;
create view v_dml as select a, f_dml (1) as c from t;
commit;


evaluate 'Case 1: ROLLBACK, SAVEPOINT, 2PC (PREPARE TO COMMIT, ATTACH) and DDL in a function invoked by SELECT';
select f_rollback () from s;
select f_savepoint () from s;
select f_prepare_to_commit () from s;
select f_attach () from s;
select f_ddl () from s;


evaluate 'Case 2: a function invoked by a subquery or DO';
select (select f_dml (2) from s) from s;
do f_dml (3);


evaluate 'Case 3: a view whose query calls a function';
-- reading is allowed
select * from v_sel order by a;
select * from v_dml;


evaluate 'Case 4: INCR () in a function invoked by SELECT, directly or through PREPARE and EXECUTE';
select f_incr () from s;
select f_incr_execute () from s;
-- a name prepared again in a loop runs the new statement, and is judged by it
select f_reprepare () from s;
select f_reprepare_incr () from s;


evaluate 'Case 5: nothing was written';
select count (*) from log_t;
select cnt from cnt_t;
select count (*) from db_class where class_name = 't_new';

--+ server-message off

drop view v_sel;
drop view v_dml;
drop function f_dml;
drop function f_sel;
drop function f_rollback;
drop function f_savepoint;
drop function f_ddl;
drop function f_prepare_to_commit;
drop function f_attach;
drop function f_incr;
drop function f_incr_execute;
drop function f_reprepare;
drop function f_reprepare_incr;
drop table t;
drop table s;
drop table log_t;
drop table cnt_t;
