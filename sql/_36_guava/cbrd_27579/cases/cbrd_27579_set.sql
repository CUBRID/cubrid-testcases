/**
 *  This test case verifies CBRD-27579: a stored procedure / function invoked inside a SQL statement
 *  may not run a SET statement that changes the transaction or the session settings.
 *
 *  SET TRANSACTION, SET SYSTEM PARAMETERS, SET OPTIMIZATION, SET TRIGGER, SET NAMES and SET TIME ZONE
 *  are judged as transaction control. SET @v only holds a value in the session and is allowed.
 *
 *  Covered by other test cases, not repeated here:
 *    SET in a procedure called alone, and SET run directly
 *
 *  Coverage:
 *    Case 1: the SET statements in a function invoked by SELECT
 *    Case 2: SET @v in a function invoked by SELECT
 */

--+ server-message on

drop table if exists s;

create table s (a int);
insert into s values (1);

create or replace function f_set_xaction return int as begin execute immediate 'set transaction isolation level 4'; return 1; end;
create or replace function f_set_sys_params return int as begin execute immediate 'set system parameters ''xasl_debug_dump=no'''; return 1; end;
create or replace function f_set_opt_lvl return int as begin execute immediate 'set optimization level 1'; return 1; end;
create or replace function f_set_trigger return int as begin execute immediate 'set trigger trace on'; return 1; end;
create or replace function f_set_names return int as begin execute immediate 'set names utf8'; return 1; end;
create or replace function f_set_timezone return int as begin execute immediate 'set time zone ''Asia/Seoul'''; return 1; end;
create or replace function f_set_var return int as x int;
begin
  execute immediate 'set @v_set = 7';
  execute immediate 'select @v_set' into x;
  return x;
end;
commit;


evaluate 'Case 1: the SET statements in a function invoked by SELECT';
select f_set_xaction () from s;
select f_set_sys_params () from s;
select f_set_opt_lvl () from s;
select f_set_trigger () from s;
select f_set_names () from s;
select f_set_timezone () from s;


evaluate 'Case 2: SET @v in a function invoked by SELECT';
select f_set_var () from s;

--+ server-message off

drop function f_set_xaction;
drop function f_set_sys_params;
drop function f_set_opt_lvl;
drop function f_set_trigger;
drop function f_set_names;
drop function f_set_timezone;
drop function f_set_var;
drop variable @v_set;
drop table s;
