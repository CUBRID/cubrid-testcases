/**
 *  This test case verifies CBRD-26470 (PR #7819): OUT and IN OUT arguments of direct calls and
 *  local routine calls are copied the same way as in a call through the server.
 *
 *  Background:
 *    - Before the fix, when no type conversion was needed, the caller's variable holder was passed
 *      to the callee as it was:
 *        . values the callee wrote to OUT/IN OUT parameters stayed in the caller's variables even
 *          when the callee ended with an exception,
 *        . the write-back conversion was skipped, so 'abcdef' went into a varchar(3) variable and
 *          3.1555 into a numeric(10,1) variable. A call through the server gives VALUE_ERROR
 *          ("string does not fit ...") and rounds to 3.2.
 *    - After the fix, OUT/IN OUT arguments always go through a temporary holder and are written
 *      back (with the conversion) only on normal return. This applies to direct calls of stored
 *      routines, direct calls of package members and calls of local routines.
 *  Each case is checked with four call forms: dir (direct call of a stored routine), pkg (direct
 *  call of a package member), loc (local routine) and srv (a call omitting a default argument,
 *  which goes through the server; control).
 *  (In SA mode an error of a call through the server fails the statement even when the caller
 *   catches it with WHEN OTHERS, so srv of Case 9-12 gives an error there. It is a separate issue.
 *   CTP runs in CS mode, where it is '7,7'.)
 *
 *  Coverage:
 *    Case 1-4:   OUT varchar 'abcdef' into a varchar(3) variable -> VALUE_ERROR ('VE')
 *    Case 5-8:   IN OUT numeric 3.1555 into a numeric(10,1) variable -> 3.2
 *    Case 9-12:  callee sets a := 77, b := 88 and raises NO_DATA_FOUND, caught by the caller
 *                -> the variables keep '7,7'
 *    Case 13-16: normal return: a := a + 1, b := 5 -> '8,5'
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


evaluate 'Case 1-4: OUT ''abcdef'' into varchar(3) (dir, pkg, loc, srv): VE, VE, VE, VE';
select s_dir58 () from dual;
select s_pkg58 () from dual;
select s_loc58 () from dual;
select s_srv58 () from dual;

evaluate 'Case 5-8: IN OUT 3.1555 into numeric(10,1) (dir, pkg, loc, srv): 3.2, 3.2, 3.2, 3.2';
select n_dir58 () from dual;
select n_pkg58 () from dual;
select n_loc58 () from dual;
select n_srv58 () from dual;

evaluate 'Case 9-12: arguments unchanged when the callee ends with an exception (dir, pkg, loc, srv): 7,7, 7,7, 7,7, 7,7';
select e_dir58 () from dual;
select e_pkg58 () from dual;
select e_loc58 () from dual;
select e_srv58 () from dual;

evaluate 'Case 13-16: arguments written back on normal return (dir, pkg, loc, srv): 8,5, 8,5, 8,5, 8,5';
select o_dir58 () from dual;
select o_pkg58 () from dual;
select o_loc58 () from dual;
select o_srv58 () from dual;


drop function s_dir58, s_pkg58, s_loc58, s_srv58;
drop function n_dir58, n_pkg58, n_loc58, n_srv58;
drop function e_dir58, e_pkg58, e_loc58, e_srv58;
drop function o_dir58, o_pkg58, o_loc58, o_srv58;
drop package pq58;
drop procedure ps58, pn58, pe58, po58;

--+ server-message off
