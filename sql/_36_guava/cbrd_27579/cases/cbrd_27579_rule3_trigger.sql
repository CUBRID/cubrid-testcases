/**
 *  This test case verifies CBRD-27579 rule 3 for a stored procedure / function invoked inside a trigger.
 *    - A row trigger keeps its trigger class and the tables of its action statement as tables of the running
 *      statement, so a stored procedure in the trigger may not write them.
 *    - Exception: if the statement that ran the trigger has no stored procedure call, the tables it only reads
 *      may be written. If it has one, its tables are tables of the running statement as well.
 *    - A statement trigger does not keep its trigger class or the statement that ran it.
 *
 *  Coverage:
 *    Case 1: a row trigger action CALL writing the trigger class or another table
 *    Case 2: the exception, by whether the statement that ran the trigger has a stored procedure call
 *    Case 3: a row trigger action statement calling a function
 *    Case 4: a statement trigger action CALL writing the trigger class
 *    Case 5: rows written by the allowed cases only
 */

--+ server-message on

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists log_t;

create table t1 (a int);
create table t2 (a int);
insert into t2 values (1);
create table t3 (a int);
insert into t3 values (1);
create table t4 (a int);
create table log_t (x int);

create or replace function f_exec (q varchar) return int as begin execute immediate q; return 1; end;
create or replace function f_zero return int as begin return 0; end;
create or replace procedure p_exec (q varchar) as begin execute immediate q; end;
commit;


evaluate 'Case 1: a row trigger action CALL writing the trigger class or another table';
create trigger tr1 after insert on t1 execute call p_exec ('insert into t1 values (99)');
insert into t1 values (1);
drop trigger tr1;
create trigger tr1 after insert on t1 execute call p_exec ('insert into log_t values (1)');
insert into t1 values (2);
drop trigger tr1;


evaluate 'Case 2: the exception, by whether the statement that ran the trigger has a stored procedure call';
create trigger tr2 after insert on t1 execute call p_exec ('insert into t2 values (10)');
-- no stored procedure call: t2 is only read by the INSERT, so writing it is allowed
insert into t1 select a from t2 where a = 1;
-- a stored procedure call: t2 is a table of the running statement
insert into t1 select a + f_zero () from t2 where a = 1;
drop trigger tr2;


evaluate 'Case 3: a row trigger action statement calling a function';
create trigger tr3 after update on t3 execute insert into log_t values (f_exec ('insert into t3 values (5)'));
update t3 set a = 2;
drop trigger tr3;
create trigger tr3 after update on t3 execute insert into log_t values (f_exec ('insert into t4 values (5)'));
update t3 set a = 3;
drop trigger tr3;


evaluate 'Case 4: a statement trigger action CALL writing the trigger class';
create trigger tr4 after statement insert on t4 execute call p_exec ('update t4 set a = a + 100');
insert into t4 values (1);
drop trigger tr4;


evaluate 'Case 5: rows written by the allowed cases only';
select a from t1 order by a;
select a from t2 order by a;
select a from t3 order by a;
select a from t4 order by a;
select x from log_t order by x;

--+ server-message off

drop function f_exec;
drop function f_zero;
drop procedure p_exec;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table log_t;
