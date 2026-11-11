/**
 *  This test case verifies CBRD-26470 (PR #7819): PL/CSQL compile checks around package routines.
 *
 *  Background:
 *    - The check that refuses PL-only types (BOOLEAN, SYS_REFCURSOR, %ROWTYPE) as parameter (s243)
 *      or return (s244) types moved from ParseTreeConverter to TypeChecker.visitDeclRoutine (),
 *      and is done only for public routines (CREATE SP or a routine of a package specification).
 *      Private routines only in the body are allowed (before, every DECL_TOP_LEVEL routine was
 *      regarded as top level and refused).
 *    - A direct call <pkg>.<routine> from another SP asks the server for the signature: private
 *      members are not visible, and the number of arguments, the updatability of OUT arguments
 *      (s417) and the routine kind are checked.
 *    - The AUTHID error of a local routine (s084) is reported at the AUTHID clause instead of the
 *      LANGUAGE token (which a local routine does not have).
 *    - <table>.<column>%TYPE in spec parameters/returns is resolved by asking the server while
 *      parsing, and spec and body headers are matched by the %TYPE text itself
 *      (TypeSpec.isSameAs). IN parameters drop the NUMERIC precision (TYPE_VISIT_PARAM_IN).
 *  (While package variables cannot be declared, the original case 5 (pkb.b%TYPE) is left out, and
 *   %TYPE of package variables is replaced with %TYPE of table columns.)
 *
 *  Coverage:
 *    Case 1:  BOOLEAN parameter of a spec procedure         -> s243 (column 47)
 *    Case 2:  SYS_REFCURSOR parameter of a spec function    -> s243
 *    Case 3:  %ROWTYPE return of a spec function            -> s244
 *    Case 4:  %ROWTYPE parameter of a spec procedure        -> s243
 *    Case 6:  private routines with PL-only types are allowed: wg55 () = 11
 *    Case 7:  SYS_REFCURSOR return of a standalone function is still allowed (regression)
 *    Case 8:  private member called from outside           -> neither ... exists
 *    Case 9:  wrong number of arguments                     -> the number of arguments ... does not match
 *    Case 10: literal to an OUT parameter                   -> must be updatable
 *    Case 11: package function called as a procedure        -> neither ... exists
 *    Case 12: package procedure called as a function        -> neither ... exists
 *    Case 13: correct calls (regression): e55_6 () = 7
 *    Case 14: AUTHID on a local procedure                   -> s084 at the AUTHID clause (column 16 of its line)
 *    Case 15: %TYPE of table columns in spec and body: pu55.h (1.234) = '1.234' (IN precision dropped)
 *    Case 16: body parameter %TYPE differs from the spec    -> header does not match
 */

--+ server-message on

drop package if exists pa55;
drop package if exists pz55;
drop package if exists pv55;
drop package if exists pu55;
drop table if exists rowt55;
drop table if exists tp55;

create table rowt55 (a int, b varchar(10));
insert into rowt55 values (1, 'x');
create or replace package pz55 as function f(a int) return int; procedure p(a int, o out int); end;
create or replace package body pz55 as function priv(a int) return int as begin return a; end; function f(a int) return int as begin return priv(a) + 1; end; procedure p(a int, o out int) as begin o := a * 3; end; end;
create table tp55 (v numeric(6,2), s varchar(5));


evaluate 'Case 1: BOOLEAN parameter of a spec procedure -> type Boolean cannot be used as a paramter type';
create or replace package pa55 as procedure p(x boolean); end;


evaluate 'Case 2: SYS_REFCURSOR parameter of a spec function -> type Sys_refcursor cannot be used as a paramter type';
create or replace package pa55 as function f(c sys_refcursor) return int; end;


evaluate 'Case 3: %ROWTYPE return of a spec function -> type ROWT55%ROWTYPE cannot be used as a return type';
create or replace package pa55 as function f return rowt55%rowtype; end;


evaluate 'Case 4: %ROWTYPE parameter of a spec procedure -> type ROWT55%ROWTYPE cannot be used as a paramter type';
create or replace package pa55 as procedure p(r rowt55%rowtype); end;


evaluate 'Case 6: private routines with PL-only types are allowed -> created, wg55 () = 11';
create or replace package pv55 as function g return int; end;
create or replace package body pv55 as
  function nb(x boolean) return boolean as begin return not x; end;
  function cnt(c sys_refcursor) return int as v int; n int := 0;
  begin
    loop fetch c into v; exit when c%notfound; n := n + v; end loop;
    close c;
    return n;
  end;
  function rec(r rowt55%rowtype) return rowt55%rowtype as begin return r; end;
  function g return int as c sys_refcursor; r rowt55%rowtype; r2 rowt55%rowtype;
  begin
    select * into r from rowt55 where a = 1;
    r2 := rec(r);
    open c for select a from rowt55;
    if nb(false) then return cnt(c) * 10 + r2.a; else return -1; end if;
  end;
end;
create or replace function wg55 return int as begin return pv55.g(); end;
select wg55() from db_root;


evaluate 'Case 7: SYS_REFCURSOR return of a standalone function (regression) -> created';
create or replace function sf_rc55 return sys_refcursor as c sys_refcursor; begin open c for select a from rowt55; return c; end;
select count(*) from db_stored_procedure where sp_name = 'sf_rc55';


evaluate 'Case 8: private member from outside -> Neither stored function pz55.priv nor package function dba.pz55.priv exists';
create or replace function e55_1 return int as begin return pz55.priv(1); end;


evaluate 'Case 9: wrong number of arguments -> the number of arguments to function PZ55.F does not match';
create or replace function e55_2 return int as begin return pz55.f(1, 2); end;


evaluate 'Case 10: literal to an OUT parameter -> argument 2 to the call of PZ55.P must be updatable';
create or replace procedure e55_3 as begin pz55.p(1, 2); end;


evaluate 'Case 11: package function called as a procedure -> Neither stored procedure pz55.f nor package procedure dba.pz55.f exists';
create or replace procedure e55_4 as begin pz55.f(1); end;


evaluate 'Case 12: package procedure called as a function -> Neither stored function pz55.p nor package function dba.pz55.p exists';
create or replace function e55_5 return int as begin return pz55.p(1, 2); end;


evaluate 'Case 13: correct calls (regression) -> e55_6 () = 7';
create or replace function e55_6 return int as o int; begin dba.pz55.p(2, o); return dba.pz55.f(o); end;
select e55_6() from db_root;


evaluate 'Case 14: AUTHID on a local procedure -> illegal keyword AUTHID at the AUTHID clause';
create or replace procedure la55 as
  procedure lp authid definer as begin null; end;
begin lp(); end;


evaluate 'Case 15: tp55.v%TYPE parameter and tp55.s%TYPE return in spec and body -> created, wu55 () = 1.234';
create or replace package pu55 as function h(x tp55.v%type) return tp55.s%type; end;
create or replace package body pu55 as function h(x tp55.v%type) return tp55.s%type as begin return x; end; end;
create or replace function wu55 return varchar as begin return pu55.h(1.234); end;
select wu55() from db_root;


evaluate 'Case 16: body parameter %TYPE differs from the spec -> the header of function H does not match';
create or replace package body pu55 as function h(x tp55.s%type) return tp55.s%type as begin return x; end; end;


drop function wg55;
drop function sf_rc55;
drop function e55_6;
drop function wu55;
drop package pz55;
drop package pv55;
drop package pu55;
drop table rowt55;
drop table tp55;

--+ server-message off
