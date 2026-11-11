/**
 *  This test case verifies CBRD-26470 (PR #7819): the error message of a routine called by a
 *  direct call has the same form as that of a call through the server.
 *
 *  Background:
 *    - Before the fix, the PlcsqlRuntimeError of the callee went up to the caller as it was, and
 *      the top-level catch of the caller overwrote its position with the caller's position, so
 *      the position inside the callee was lost:
 *        (line 3, column 24) numeric value does not fit ...
 *    - After the fix, SpLib.invokeMethod puts the position in the callee into the message
 *      (PlcsqlRuntimeError.nestInCaller) and clears the position. The message is the same as that
 *      of a call through the server. The exception kind is kept, so the caller can still catch it
 *      with WHEN NO_DATA_FOUND and so on:
 *        Stored procedure execute error:
 *          (line 3, column 24) Stored procedure execute error:
 *          (line 3, column 8) numeric value does not fit ...
 *  In each case the message of dir (direct call of a stored routine) must be the same as that of
 *  srv (a call omitting a default argument, which goes through the server). The call sites of dir,
 *  pkg and srv are at the same line and column.
 *  pkg (direct call of a package member) is compared with the expected message. The entry version
 *  of a public package member puts its own position into its errors, so the innermost position is
 *  the one in the package body. A package member cannot be called through the server.
 *  The routine bodies are not indented, so that the positions do not depend on the indentation.
 *
 *  Coverage:
 *    Case 1-2: function call expression (as cbrd_26884 Case 21)
 *    Case 3-4: procedure call statement
 *    Case 5-6: three levels of calls (a -> b -> c): the position is wrapped twice
 *    Case 7-8: NO_DATA_FOUND of the callee is caught by WHEN NO_DATA_FOUND in the caller, and
 *              SQLERRM has the position
 */

--+ server-message on

drop table if exists t61;
drop package if exists pq61;

create table t61 (c numeric(20,15));
create or replace function fc61 (d int := 0) return t61.c%type as
begin
return 123456789012345678901234;
end;
create or replace package pq61 as
function fc return t61.c%type;
procedure pc;
function f3b return varchar;
procedure pn;
end;
create or replace package body pq61 as
function fc return t61.c%type as
begin
return 123456789012345678901234;
end;
procedure pc as
n t61.c%type;
begin
n := 123456789012345678901234;
end;
function f3b return varchar as
begin
return 'b ' || dba.fc61(0);
end;
procedure pn as
n int;
begin
select 1 into n from db_root where 1 = 0;
end;
end;
create or replace function f_dir61 return varchar as
begin
return 'v_numeric ' || fc61(0);
end;
create or replace function f_pkg61 return varchar as
begin
return 'v_numeric ' || pq61.fc();
end;
create or replace function f_srv61 return varchar as
begin
return 'v_numeric ' || fc61( );
end;

create or replace procedure pc61 (d int := 0) as
n t61.c%type;
begin
n := 123456789012345678901234;
end;
create or replace function p_dir61 return varchar as
begin
pc61(0); return 'x';
end;
create or replace function p_pkg61 return varchar as
begin
pq61.pc(); return 'x';
end;
create or replace function p_srv61 return varchar as
begin
pc61( ); return 'x';
end;

create or replace function f3b61 (d int := 0) return varchar as
begin
return 'b ' || fc61(0);
end;
create or replace function a_dir61 return varchar as
begin
return 'a ' || f3b61(0);
end;
create or replace function a_pkg61 return varchar as
begin
return 'a ' || pq61.f3b();
end;
create or replace function a_srv61 return varchar as
begin
return 'a ' || f3b61( );
end;

create or replace procedure pn61 (d int := 0) as
n int;
begin
select 1 into n from db_root where 1 = 0;
end;
create or replace function n_dir61 return varchar as
begin
pn61(0); return 'x';
exception when no_data_found then return 'NDF:' || replace(sqlerrm, chr(10), '|');
end;
create or replace function n_pkg61 return varchar as
begin
pq61.pn(); return 'x';
exception when no_data_found then return 'NDF:' || replace(sqlerrm, chr(10), '|');
end;


evaluate 'Case 1-2: function call. srv, dir: (line 3, column 24) wraps (line 3, column 8); pkg: (line 3, column 24) wraps (line 4, column 8)';
select f_srv61 () from dual;
select f_dir61 () from dual;
select f_pkg61 () from dual;

evaluate 'Case 3-4: procedure call. srv, dir: (line 3, column 1) wraps (line 4, column 6); pkg: (line 3, column 1) wraps (line 9, column 6)';
select p_srv61 () from dual;
select p_dir61 () from dual;
select p_pkg61 () from dual;

evaluate 'Case 5-6: three levels. srv, dir: (line 3, column 16) wraps (line 3, column 16) wraps (line 3, column 8); pkg: (line 3, column 16) wraps (line 13, column 16) wraps (line 3, column 8)';
select a_srv61 () from dual;
select a_dir61 () from dual;
select a_pkg61 () from dual;

evaluate 'Case 7-8: NO_DATA_FOUND caught in the caller. dir: NDF with (line 4, column 1); pkg: NDF with (line 18, column 1)';
select n_dir61 () from dual;
select n_pkg61 () from dual;


drop function f_dir61, f_pkg61, f_srv61, p_dir61, p_pkg61, p_srv61, a_dir61, a_pkg61, a_srv61, n_dir61, n_pkg61;
drop function fc61, f3b61;
drop procedure pc61, pn61;
drop package pq61;
drop table t61;

--+ server-message off
