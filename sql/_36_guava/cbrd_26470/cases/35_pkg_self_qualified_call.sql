/**
 *  This test case verifies CBRD-26470: qualified calls inside a package (dba.tag (), pk.tag (),
 *  dba.pk.tag ()) are resolved correctly.
 *
 *  Before the fix previsitRoutine_decl () overwrote spName for every package routine, so the name
 *  of the last routine of the body was left. If that routine was tag, dba.tag () was bound to the
 *  package tag instead of the standalone function. pk.tag () and dba.pk.tag () were global calls
 *  (through the server), so they did not find private members, and replacing the spec failed to
 *  recompile the body (X3). Now a qualifier that names the unit being compiled (SP:
 *  <owner>.<sp>, package: <pkg>, <owner>.<pkg>) looks up the name only at the top level of that
 *  unit and makes a local call; if it is not there, it is a compile error. Other qualified calls
 *  (dba.tag () etc.) are global calls.
 *
 *  Standalone function tag35 returns 'standalone', standalone procedure ptag35 (o) sets o to
 *  'standalone'. Each case calls the package through the wrapper function w35.
 *
 *  Coverage:
 *    Case 1:  function, tag35 is the last routine of the body:
 *             dba.tag35 / tag35 / pk.tag35 / dba.pk.tag35 = standalone/pkg/pkg/pkg
 *    Case 2:  function, tag35 is the first routine of the body: the same
 *    Case 3:  procedure, ptag35 is the last routine of the body: the same
 *    Case 4:  private member: pk.h () / dba.pk.h () = private/private
 *    Case 5:  pk.tag35 () in a routine with a local function tag35 = pkg
 *    Case 6:  another package pk35_o.f () = pk35_o (global call, regression)
 *    Case 7:  pk.nosuch35 () is an error (no such function) even if standalone nosuch35 exists
 *    Case 8:  pk.nosuchp () is an error (no such procedure)
 *    Case 9:  dba.g35 () in package routine g35 without a standalone g35 is an error
 *    Case 10: X3, replacing the spec when the body has pk.tag35 (), then the call = pkg
 *    Case 11: <owner>.<name> recursion of a standalone function and procedure = 10/10 (regression)
 */

--+ server-message on

drop package if exists pk35_o;
drop package if exists pk35_1;
drop package if exists pk35_2;
drop package if exists pk35_3;
drop package if exists pk35_4;
drop package if exists pk35_5;
drop package if exists pk35_6;
drop package if exists pk35_7;
drop package if exists pk35_8;
drop package if exists pk35_9;
drop package if exists pk35_10;
create or replace function tag35 return varchar as begin return 'standalone'; end;
create or replace function nosuch35 return varchar as begin return 'standalone nosuch'; end;
create or replace procedure ptag35 (o out varchar) as begin o := 'standalone'; end;
create or replace package pk35_o as function f return varchar; end;
create or replace package body pk35_o as function f return varchar as begin return 'pk35_o'; end; end;


evaluate 'Case 1: function, tag35 last: standalone/pkg/pkg/pkg';
create or replace package pk35_1 as function f return varchar; function tag35 return varchar; end;
create or replace package body pk35_1 as function f return varchar as begin return dba.tag35 () || '/' || tag35 () || '/' || pk35_1.tag35 () || '/' || dba.pk35_1.tag35 (); end; function tag35 return varchar as begin return 'pkg'; end; end;
create or replace function w35 return varchar as begin return pk35_1.f (); end;
select w35 () from dual;


evaluate 'Case 2: function, tag35 first: standalone/pkg/pkg/pkg';
create or replace package pk35_2 as function f return varchar; function tag35 return varchar; end;
create or replace package body pk35_2 as function tag35 return varchar as begin return 'pkg'; end; function f return varchar as begin return dba.tag35 () || '/' || tag35 () || '/' || pk35_2.tag35 () || '/' || dba.pk35_2.tag35 (); end; end;
create or replace function w35 return varchar as begin return pk35_2.f (); end;
select w35 () from dual;


evaluate 'Case 3: procedure, ptag35 last: standalone/pkg/pkg/pkg';
create or replace package pk35_3 as function f return varchar; procedure ptag35 (o out varchar); end;
create or replace package body pk35_3 as function f return varchar as a varchar; b varchar; c varchar; d varchar; begin dba.ptag35 (a); ptag35 (b); pk35_3.ptag35 (c); dba.pk35_3.ptag35 (d); return a || '/' || b || '/' || c || '/' || d; end; procedure ptag35 (o out varchar) as begin o := 'pkg'; end; end;
create or replace function w35 return varchar as begin return pk35_3.f (); end;
select w35 () from dual;


evaluate 'Case 4: private member: private/private';
create or replace package pk35_4 as function f return varchar; end;
create or replace package body pk35_4 as function h return varchar as begin return 'private'; end; function f return varchar as begin return pk35_4.h () || '/' || dba.pk35_4.h (); end; end;
create or replace function w35 return varchar as begin return pk35_4.f (); end;
select w35 () from dual;


evaluate 'Case 5: a local function does not hide the member: pkg';
create or replace package pk35_5 as function f return varchar; function tag35 return varchar; end;
create or replace package body pk35_5 as function f return varchar as function tag35 return varchar as begin return 'local'; end; begin return pk35_5.tag35 (); end; function tag35 return varchar as begin return 'pkg'; end; end;
create or replace function w35 return varchar as begin return pk35_5.f (); end;
select w35 () from dual;


evaluate 'Case 6: other package (regression): pk35_o';
create or replace package pk35_6 as function f return varchar; end;
create or replace package body pk35_6 as function f return varchar as begin return pk35_o.f (); end; end;
create or replace function w35 return varchar as begin return pk35_6.f (); end;
select w35 () from dual;


evaluate 'Case 7: pk35_7.nosuch35 () is refused: no such function';
create or replace package pk35_7 as function f return varchar; end;
create or replace package body pk35_7 as function f return varchar as begin return pk35_7.nosuch35 (); end; end;


evaluate 'Case 8: pk35_8.nosuchp () is refused: no such procedure';
create or replace package pk35_8 as procedure p; end;
create or replace package body pk35_8 as procedure p as begin pk35_8.nosuchp (); end; end;


evaluate 'Case 9: dba.g35 () without a standalone g35 is refused: Neither stored function dba.g35 ...';
create or replace package pk35_9 as function g35 return varchar; end;
create or replace package body pk35_9 as function g35 return varchar as begin return dba.g35 (); end; end;


evaluate 'Case 10: X3, replace the spec, then the call: pkg';
create or replace package pk35_10 as function f return varchar; function tag35 return varchar; end;
create or replace package body pk35_10 as function f return varchar as begin return pk35_10.tag35 (); end; function tag35 return varchar as begin return 'pkg'; end; end;
create or replace package pk35_10 as function f return varchar; function tag35 return varchar; end;
create or replace function w35 return varchar as begin return pk35_10.f (); end;
select w35 () from dual;


evaluate 'Case 11: standalone recursion (regression): 10/10';
create or replace function sf35 (n int) return int as begin if n <= 0 then return 0; end if; return n + dba.sf35 (n - 1); end;
create or replace procedure sp35 (n int, o in out int) as begin if n > 0 then o := o + n; dba.sp35 (n - 1, o); end if; end;
create or replace function w35 return varchar as o int := 0; begin sp35 (4, o); return sf35 (4) || '/' || o; end;
select w35 () from dual;

drop function w35, sf35, tag35, nosuch35;
drop procedure sp35, ptag35;
drop package pk35_o;
drop package pk35_1;
drop package pk35_2;
drop package pk35_3;
drop package pk35_4;
drop package pk35_5;
drop package pk35_6;
drop package pk35_7;
drop package pk35_8;
drop package pk35_9;
drop package pk35_10;

--+ server-message off
