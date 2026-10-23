/**
 *  This test case verifies CBRD-27579: a nested call inherits the statement its caller was invoked in.
 *
 *  A procedure called by CALL alone is not restricted, but a call made while a SQL statement is
 *  running (SELECT -> function -> CALL) is still inside that statement and may not run DML.
 *
 *  Coverage:
 *    Case 1: SELECT -> function -> CALL -> DML
 *    Case 2: CALL -> SELECT -> function -> DML
 *    Case 3: CALL -> SELECT ends -> the procedure's own DML
 *    Case 4: rows written by the allowed cases only
 */

--+ server-message on

drop table if exists s;
drop table if exists log_t;

create table s (a int);
insert into s values (1);
create table log_t (x int);

create or replace procedure p_dml (n int) as begin insert into log_t values (n); end;
create or replace function f_dml (n int) return int as begin insert into log_t values (n); return 1; end;
create or replace function f_sel return int as c int; begin select count (*) into c from s; return c; end;
create or replace function f_call return int as begin execute immediate 'call p_dml (1)'; return 1; end;
create or replace procedure p_sel_dml as c int; begin select f_dml (2) into c from s; end;
create or replace procedure p_sel_then_dml as c int; begin select f_sel () into c from s; insert into log_t values (3); end;
commit;


evaluate 'Case 1: SELECT -> function -> CALL -> DML';
select f_call () from s;


evaluate 'Case 2: CALL -> SELECT -> function -> DML';
call p_sel_dml ();


evaluate 'Case 3: CALL -> SELECT ends -> the procedure''s own DML';
call p_sel_then_dml ();


evaluate 'Case 4: rows written by the allowed cases only';
select x from log_t order by x;

--+ server-message off

drop procedure p_dml;
drop function f_dml;
drop function f_sel;
drop function f_call;
drop procedure p_sel_dml;
drop procedure p_sel_then_dml;
drop table s;
drop table log_t;
