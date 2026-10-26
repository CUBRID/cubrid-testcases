/**
 *  This test case verifies CBRD-27579: a stored procedure / function invoked in a trigger may not end
 *  the transaction or run DDL.
 *
 *  A trigger action CALL runs after the statement has read its target rows, so the procedure may
 *  run DML. A trigger condition or a function in a trigger action statement is inside a SQL
 *  statement, so it may not run DML either.
 *
 *  Coverage:
 *    Case 1: trigger action CALL running DML
 *    Case 2: trigger action CALL running COMMIT or DDL
 *    Case 3: trigger condition and trigger action statement calling a function that runs DML
 *    Case 4: rows written by the allowed cases only
 */

--+ server-message on

drop table if exists tr1;
drop table if exists tr2;
drop table if exists tr3;
drop table if exists tr4;
drop table if exists tr5;
drop table if exists log_t;
drop table if exists t_new;

create table tr1 (a int);
create table tr2 (a int);
create table tr3 (a int);
create table tr4 (a int);
create table tr5 (a int);
create table log_t (x int);

create or replace procedure p_dml (n int) as begin insert into log_t values (n); end;
create or replace procedure p_commit as begin insert into log_t values (2); commit; end;
create or replace procedure p_ddl as begin execute immediate 'create table t_new (a int)'; end;
create or replace function f_dml (n int) return int as begin insert into log_t values (n); return 1; end;

create trigger tr_call_dml after insert on tr1 execute call p_dml (1);
create trigger tr_call_commit after insert on tr2 execute call p_commit ();
create trigger tr_call_ddl after insert on tr3 execute call p_ddl ();
create trigger tr_cond_dml after insert on tr4 if f_dml (4) > 0 execute print 'tr4';
create trigger tr_expr_dml after insert on tr5 execute insert into log_t values (f_dml (5));
commit;


evaluate 'Case 1: trigger action CALL running DML';
insert into tr1 values (1);


evaluate 'Case 2: trigger action CALL running COMMIT or DDL';
insert into tr2 values (1);
insert into tr3 values (1);


evaluate 'Case 3: trigger condition and trigger action statement calling a function that runs DML';
insert into tr4 values (1);
insert into tr5 values (1);


evaluate 'Case 4: rows written by the allowed cases only';
select (select count (*) from tr1), (select count (*) from tr2), (select count (*) from tr3),
       (select count (*) from tr4), (select count (*) from tr5) from db_root;
select x from log_t order by x;
select count (*) from db_class where class_name = 't_new';

--+ server-message off

drop trigger tr_call_dml;
drop trigger tr_call_commit;
drop trigger tr_call_ddl;
drop trigger tr_cond_dml;
drop trigger tr_expr_dml;
drop procedure p_dml;
drop procedure p_commit;
drop procedure p_ddl;
drop function f_dml;
drop table tr1;
drop table tr2;
drop table tr3;
drop table tr4;
drop table tr5;
drop table log_t;
