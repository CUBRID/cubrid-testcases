/**
 *  This test case verifies CBRD-26470: %TYPE with a too long owner or table name fails to compile
 *  instead of hitting an assertion.
 *
 *  Before the fix normalize_id () in method_callback.cpp only checked the total length and called
 *  sm_user_specified_name (), whose assertion failed (core dump in a debug build) when the owner
 *  of <owner>.<name> was 32 bytes or longer or the name was 223 bytes or longer. Now
 *  user_specified_name_fits () also checks the parts, and a name that does not fit gives a
 *  compile error, as a too long total does.
 *
 *  Each case creates a procedure with a variable of the %TYPE and then checks that the
 *  connection is alive.
 *
 *  Coverage:
 *    Case 1: <40-byte owner>.t28.c%TYPE (table column): compile error
 *    Case 2: dba.<230-byte table>.c%TYPE: compile error
 *    Case 3: <40-byte owner>.pk28.x%TYPE (package variable form): compile error
 *    Case 4: 31-byte owner (passes the check, not found): compile error
 *    Case 5: 32-byte owner: compile error
 *    Case 6: 223-byte table name: compile error
 *    Case 7: 222-byte table name (exists): compiles
 *    Case 8: a function with a variable of that column type runs and returns the column value
 */

--+ server-message on

drop table if exists t28;
drop table if exists k28kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk;
create table t28 (c int);
create table k28kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk (c varchar(10));


evaluate 'Case 1: 40-byte owner, table column: compile error';
create or replace procedure p28 as v uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.t28.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 2: 230-byte table name: compile error';
create or replace procedure p28 as v dba.kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 3: 40-byte owner, package variable: compile error';
create or replace procedure p28 as v uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.pk28.x%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 4: 31-byte owner (not found): compile error';
create or replace procedure p28 as v uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.t28.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 5: 32-byte owner: compile error';
create or replace procedure p28 as v uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.t28.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 6: 223-byte table name: compile error';
create or replace procedure p28 as v dba.kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 7: 222-byte table name (exists): compiles';
create or replace procedure p28 as v dba.k28kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk.c%TYPE; begin null; end;
select 'alive' from dual;


evaluate 'Case 8: a function with a variable of the 222-byte table column type returns abc';
create or replace function f28 return varchar as v dba.k28kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk.c%TYPE; begin v := 'abc'; return v; end;
select f28() from dual;

drop procedure p28;
drop function f28;
drop table t28;
drop table k28kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk;

--+ server-message off
