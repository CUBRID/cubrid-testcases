/**
 *  This test case verifies CBRD-27579 rule 3 for a stored procedure / function invoked inside a trigger.
 *    - A row trigger keeps its trigger class and the tables of its action statement as tables of the running
 *      statement, so a stored procedure in the trigger may not write them.
 *    - Exception: if the statement that ran the trigger has no stored procedure call, the tables it only reads
 *      may be written. If it has one, its tables are tables of the running statement as well.
 *    - A statement trigger does not keep its trigger class or the statement that ran it.
 *    - The deferred part of a row trigger runs after the statement that fired it ends, so it does not keep its
 *      trigger class either. Rule 1 and the frames of a running outer statement still apply.
 *
 *  Coverage:
 *    Case 1: a row trigger action CALL writing the trigger class or another table
 *    Case 2: the exception, by whether the statement that ran the trigger has a stored procedure call
 *    Case 3: a row trigger action statement calling a function
 *    Case 4: a statement trigger action CALL writing the trigger class
 *    Case 5: a deferred row trigger (action at COMMIT, condition at the statement, COMMIT in the action,
 *            EXECUTE DEFERRED TRIGGER inside an outer UPDATE)
 *    Case 6: rows written by the allowed cases only
 */

--+ server-message on

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop table if exists log_t;

create table t1 (a int);
create table t2 (a int);
insert into t2 values (1);
create table t3 (a int);
insert into t3 values (1);
create table t4 (a int);
create table t5 (a int);
insert into t5 values (1);
create table log_t (x int);

create or replace function f_exec (q varchar) return int as begin execute immediate q; return 1; end;
create or replace function f_zero return int as begin return 0; end;
create or replace procedure p_exec (q varchar) as begin execute immediate q; end;
create or replace procedure p_commit as begin commit; end;
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


evaluate 'Case 5: a deferred row trigger';
autocommit off;
-- the deferred action runs at COMMIT, after the UPDATE ends, so writing the trigger class is allowed
create trigger tr5 after update on t5 execute deferred call p_exec ('insert into t5 values (50)');
commit;
update t5 set a = 2 where a = 1;
commit;
drop trigger tr5;
-- the condition runs with the UPDATE, so writing the trigger class there is refused
create trigger tr5 before update on t5 if f_exec ('insert into t5 values (51)') = 1 execute deferred call p_exec ('insert into log_t values (51)');
commit;
update t5 set a = 3 where a = 2;
rollback;
drop trigger tr5;
-- rule 1 still applies to the deferred action
create trigger tr5 after update on t5 execute deferred call p_commit ();
commit;
update t5 set a = 2 where a = 2;
commit;
rollback;
drop trigger tr5;
-- the frame of a running outer UPDATE still applies to the deferred action it runs
create trigger tr5 after update on t5 execute deferred call p_exec ('insert into log_t values (52)');
commit;
update t5 set a = 5 where a = 2;
update log_t set x = f_exec ('execute deferred trigger tr5');
rollback;
drop trigger tr5;
commit;
autocommit on;


evaluate 'Case 6: rows written by the allowed cases only';
select a from t1 order by a;
select a from t2 order by a;
select a from t3 order by a;
select a from t4 order by a;
select a from t5 order by a;
select x from log_t order by x;

--+ server-message off

drop function f_exec;
drop function f_zero;
drop procedure p_exec;
drop procedure p_commit;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
drop table log_t;
