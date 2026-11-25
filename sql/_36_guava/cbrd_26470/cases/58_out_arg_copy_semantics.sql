/**
 *  This test case verifies CBRD-26470 (PR #7819): OUT and IN OUT arguments of direct calls and
 *  local routine calls are copied the same way as in a call through the server.
 *
 *  Background:
 *    - Before the fix, when no type conversion was needed, the variable holder of the caller was
 *      passed to the callee as it was:
 *        . values the callee wrote to OUT/IN OUT parameters stayed in the variables of the caller
 *          even when the callee ended with an exception,
 *        . the write-back conversion was skipped, so the 6-character string abcdef went into a
 *          varchar(3) variable and 3.1555 into a numeric(10,1) variable unrounded. A call through
 *          the server gives VALUE_ERROR (string does not fit) and rounds the number.
 *    - After the fix, OUT/IN OUT arguments always go through a temporary holder and are written
 *      back (with the conversion) only on normal return. This applies to direct calls of stored
 *      routines, direct calls of package members and calls of local routines.
 *  Each check runs with four call forms: dir (direct call of a stored routine), pkg (direct
 *  call of a package member), loc (local routine) and srv (a call omitting a default argument,
 *  which goes through the server; control).
 *  (In SA mode an error of a call through the server fails the statement even when the caller
 *   catches it with WHEN OTHERS, so srv of Case 12 gives an error there. It is a separate issue.
 *   CTP runs in CS mode, where the caller catches it.)
 *
 *  Coverage:
 *    Case 1:  dir, OUT varchar abcdef into a varchar(3) variable -> VALUE_ERROR caught by the caller
 *    Case 2:  pkg, the same as Case 1
 *    Case 3:  loc, the same as Case 1
 *    Case 4:  srv, the same as Case 1 (control)
 *    Case 5:  dir, IN OUT numeric 3.1555 into a numeric(10,1) variable -> rounded to one digit
 *    Case 6:  pkg, the same as Case 5
 *    Case 7:  loc, the same as Case 5
 *    Case 8:  srv, the same as Case 5 (control)
 *    Case 9:  dir, the callee sets a := 77, b := 88 and raises NO_DATA_FOUND, caught by the caller
 *             -> the variables keep their values from before the call
 *    Case 10: pkg, the same as Case 9
 *    Case 11: loc, the same as Case 9
 *    Case 12: srv, the same as Case 9 (control)
 *    Case 13: dir, normal return: a := a + 1, b := 5 -> both written back
 *    Case 14: pkg, the same as Case 13
 *    Case 15: loc, the same as Case 13
 *    Case 16: srv, the same as Case 13 (control)
 */

--+ server-message on

drop package if exists pq58;

create or replace procedure ps58 (x out varchar, d int := 0) as begin x := 'abcdef'; end;
create or replace procedure pn58 (y in out numeric, d int := 0) as begin y := y * 2 + 0.5555; end;
create or replace procedure pe58 (a in out int, b out int, d int := 0) as begin a := 77; b := 88; raise no_data_found; end;
create or replace procedure po58 (a in out int, b out int, d int := 0) as begin a := a + 1; b := 5; end;
create or replace package pq58 as
procedure ps (x out varchar);
procedure pn (y in out numeric);
procedure pe (a in out int, b out int);
procedure po (a in out int, b out int);
end;
create or replace package body pq58 as
procedure ps (x out varchar) as begin x := 'abcdef'; end;
procedure pn (y in out numeric) as begin y := y * 2 + 0.5555; end;
procedure pe (a in out int, b out int) as begin a := 77; b := 88; raise no_data_found; end;
procedure po (a in out int, b out int) as begin a := a + 1; b := 5; end;
end;

create or replace function s_dir58 return varchar as s varchar(3);
begin ps58 (s, 0); return s; exception when value_error then return 'VE'; end;
create or replace function s_pkg58 return varchar as s varchar(3);
begin pq58.ps (s); return s; exception when value_error then return 'VE'; end;
create or replace function s_loc58 return varchar as s varchar(3);
procedure lps (x out varchar) as begin x := 'abcdef'; end;
begin lps (s); return s; exception when value_error then return 'VE'; end;
create or replace function s_srv58 return varchar as s varchar(3);
begin ps58 (s); return s; exception when value_error then return 'VE'; end;

create or replace function n_dir58 return varchar as n numeric(10,1) := 1.3; begin pn58 (n, 0); return n; end;
create or replace function n_pkg58 return varchar as n numeric(10,1) := 1.3; begin pq58.pn (n); return n; end;
create or replace function n_loc58 return varchar as n numeric(10,1) := 1.3;
procedure lpn (y in out numeric) as begin y := y * 2 + 0.5555; end;
begin lpn (n); return n; end;
create or replace function n_srv58 return varchar as n numeric(10,1) := 1.3; begin pn58 (n); return n; end;

create or replace function e_dir58 return varchar as i int := 7; j int := 7;
begin begin pe58 (i, j, 0); exception when others then null; end; return i || ',' || j; end;
create or replace function e_pkg58 return varchar as i int := 7; j int := 7;
begin begin pq58.pe (i, j); exception when others then null; end; return i || ',' || j; end;
create or replace function e_loc58 return varchar as i int := 7; j int := 7;
procedure lpe (a in out int, b out int) as begin a := 77; b := 88; raise no_data_found; end;
begin begin lpe (i, j); exception when others then null; end; return i || ',' || j; end;
create or replace function e_srv58 return varchar as i int := 7; j int := 7;
begin begin pe58 (i, j); exception when others then null; end; return i || ',' || j; end;

create or replace function o_dir58 return varchar as i int := 7; j int := 7; begin po58 (i, j, 0); return i || ',' || j; end;
create or replace function o_pkg58 return varchar as i int := 7; j int := 7; begin pq58.po (i, j); return i || ',' || j; end;
create or replace function o_loc58 return varchar as i int := 7; j int := 7;
procedure lpo (a in out int, b out int) as begin a := a + 1; b := 5; end;
begin lpo (i, j); return i || ',' || j; end;
create or replace function o_srv58 return varchar as i int := 7; j int := 7; begin po58 (i, j); return i || ',' || j; end;


evaluate 'Case 1: dir, OUT abcdef into varchar(3); result = VE';
select s_dir58 () from dual;

evaluate 'Case 2: pkg, OUT abcdef into varchar(3); result = VE';
select s_pkg58 () from dual;

evaluate 'Case 3: loc, OUT abcdef into varchar(3); result = VE';
select s_loc58 () from dual;

evaluate 'Case 4: srv, OUT abcdef into varchar(3) (control); result = VE';
select s_srv58 () from dual;

evaluate 'Case 5: dir, IN OUT 3.1555 into numeric(10,1); result = 3.2';
select n_dir58 () from dual;

evaluate 'Case 6: pkg, IN OUT 3.1555 into numeric(10,1); result = 3.2';
select n_pkg58 () from dual;

evaluate 'Case 7: loc, IN OUT 3.1555 into numeric(10,1); result = 3.2';
select n_loc58 () from dual;

evaluate 'Case 8: srv, IN OUT 3.1555 into numeric(10,1) (control); result = 3.2';
select n_srv58 () from dual;

evaluate 'Case 9: dir, arguments unchanged when the callee ends with an exception; result = 7,7';
select e_dir58 () from dual;

evaluate 'Case 10: pkg, arguments unchanged when the callee ends with an exception; result = 7,7';
select e_pkg58 () from dual;

evaluate 'Case 11: loc, arguments unchanged when the callee ends with an exception; result = 7,7';
select e_loc58 () from dual;

evaluate 'Case 12: srv, arguments unchanged when the callee ends with an exception (control); result = 7,7';
select e_srv58 () from dual;

evaluate 'Case 13: dir, arguments written back on normal return; result = 8,5';
select o_dir58 () from dual;

evaluate 'Case 14: pkg, arguments written back on normal return; result = 8,5';
select o_pkg58 () from dual;

evaluate 'Case 15: loc, arguments written back on normal return; result = 8,5';
select o_loc58 () from dual;

evaluate 'Case 16: srv, arguments written back on normal return (control); result = 8,5';
select o_srv58 () from dual;


drop function s_dir58, s_pkg58, s_loc58, s_srv58;
drop function n_dir58, n_pkg58, n_loc58, n_srv58;
drop function e_dir58, e_pkg58, e_loc58, e_srv58;
drop function o_dir58, o_pkg58, o_loc58, o_srv58;
drop package pq58;
drop procedure ps58, pn58, pe58, po58;

--+ server-message off
