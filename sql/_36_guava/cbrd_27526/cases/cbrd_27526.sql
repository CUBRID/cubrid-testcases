/**
 *  This test case verifies CBRD-27526: calling a package routine in SQL.
 *
 *  SELECT pkg.f (...), SELECT u.pkg.f (...), CALL pkg.p (...) and CALL u.pkg.p (...) call a
 *  package routine. A name <a>.<b> reads as the routine <b> of the user <a> and also as the
 *  routine <b> of the package <a> of the current user. A name that matches both is ambiguous.
 *  In an expression only functions are counted, and in a CALL statement functions and
 *  procedures are. Before the fix SQL could not call a package routine at all.
 *
 *  Users: ux27526 owns standalone routines and is also the name of a package of u1_27526,
 *  uw27526 owns the routines that the views call, uz27526 owns the routine that a PL/CSQL
 *  function calls, and u1_27526 and u2_27526 run the cases. A procedure returns its result
 *  through an OUT parameter, so that a CALL shows which procedure ran.
 *
 *  Coverage:
 *    Case 1:  SELECT ux27526.ff () - a standalone function and a package function - is ambiguous
 *    Case 2:  CALL ux27526.ff () is ambiguous too
 *    Case 3:  SELECT ux27526.fp () - a standalone function and a package procedure - calls the function
 *    Case 4:  CALL ux27526.fp () is ambiguous
 *    Case 5:  SELECT ux27526.pf () - a standalone procedure and a package function - calls the function
 *    Case 6:  CALL ux27526.pf () is ambiguous
 *    Case 7:  SELECT ux27526.pp () - two procedures - fails as a procedure called in an expression
 *    Case 8:  CALL ux27526.pp () is ambiguous
 *    Case 9:  a name of a standalone routine only calls it
 *    Case 10: a name of a package function only calls it in the select list, WHERE, a subquery,
 *             and with default arguments
 *    Case 11: CALL of a package procedure, and CALL of a package function with and without INTO
 *    Case 12: user.package.routine is never ambiguous, in SELECT and in CALL
 *    Case 13: a routine that does not exist fails
 *    Case 14: a routine of a package without a body fails when it runs
 *    Case 15: an unqualified name is not read as a routine of a package named after the current user
 *    Case 16: a package name longer than a user name can be, in any letter case
 *    Case 17: a view reads its routine names again as the view owner
 *    Case 18: EXECUTE on the package is checked, and a routine that is not granted is still counted
 *    Case 19: static SQL of a PL/CSQL function reads its names as the owner of the function,
 *             and an ambiguous name in it fails the compile
 *    Case 20: static SQL is read again when it runs, so a package created later makes a name ambiguous
 *    Case 21: static SQL in a package body does not read an unqualified name as a routine of the package
 *    Case 22: the same SQL text run by two users calls the package of each user
 *    Case 23: dbms_output.put_line called by the user public is not ambiguous
 */

--+ holdcas on;

create user ux27526;
create user uw27526;
create user uz27526;
create user u1_27526;
create user u2_27526;

-- standalone routines of ux27526
create or replace function ux27526.ff return varchar as begin return 'ux27526.ff (standalone)'; end;
create or replace function ux27526.fp return varchar as begin return 'ux27526.fp (standalone)'; end;
create or replace procedure ux27526.pf (r out varchar) as begin r := 'ux27526.pf (standalone)'; end;
create or replace procedure ux27526.pp (r out varchar) as begin r := 'ux27526.pp (standalone)'; end;
create or replace function ux27526.so return varchar as begin return 'ux27526.so (standalone)'; end;
create or replace function ux27526.np return varchar as begin return 'ux27526.np (standalone)'; end;
grant execute on procedure ux27526.ff to public;
grant execute on procedure ux27526.fp to public;
grant execute on procedure ux27526.pf to public;
grant execute on procedure ux27526.pp to public;
grant execute on procedure ux27526.so to public;

-- standalone routines that the views and a PL/CSQL function call
create or replace function uw27526.vs return varchar as begin return 'uw27526.vs (standalone)'; end;
create or replace function uw27526.vt return varchar as begin return 'uw27526.vt (standalone)'; end;
create or replace function uz27526.zf return varchar as begin return 'uz27526.zf (standalone)'; end;
grant execute on procedure uw27526.vs to public;
grant execute on procedure uw27526.vt to public;
grant execute on procedure uz27526.zf to public;

-- the package ux27526 of u1_27526, named after the user ux27526
create or replace package u1_27526.ux27526 as
  function ff return varchar;
  procedure fp (r out varchar);
  function pf return varchar;
  procedure pp (r out varchar);
  function po return varchar;
  procedure pq (r out varchar);
  function pa (a int, b int := 10) return int;
end;
create or replace package body u1_27526.ux27526 as
  function ff return varchar as begin return 'u1_27526.ux27526.ff (package)'; end;
  procedure fp (r out varchar) as begin r := 'u1_27526.ux27526.fp (package)'; end;
  function pf return varchar as begin return 'u1_27526.ux27526.pf (package)'; end;
  procedure pp (r out varchar) as begin r := 'u1_27526.ux27526.pp (package)'; end;
  function po return varchar as begin return 'u1_27526.ux27526.po (package)'; end;
  procedure pq (r out varchar) as begin r := 'u1_27526.ux27526.pq (package)'; end;
  function pa (a int, b int := 10) return int as begin return a + b; end;
end;

-- a package without a body
create or replace package u1_27526.nobody27526 as function f return int; procedure p; end;

-- standalone routines of u1_27526, and a package u1_27526 named after their owner
create or replace function u1_27526.g return varchar as begin return 'u1_27526.g (standalone)'; end;
create or replace procedure u1_27526.q (r out varchar) as begin r := 'u1_27526.q (standalone)'; end;
create or replace package u1_27526.u1_27526 as
  function g return varchar;
  procedure q (r out varchar);
end;
create or replace package body u1_27526.u1_27526 as
  function g return varchar as begin return 'u1_27526.u1_27526.g (package)'; end;
  procedure q (r out varchar) as begin r := 'u1_27526.u1_27526.q (package)'; end;
end;

-- a package name of 41 bytes, longer than a user name can be (32 bytes)
create or replace package u1_27526.pkg_named_longer_than_any_user_name_27526 as
  function lf return varchar;
  procedure lp (r out varchar);
end;
create or replace package body u1_27526.pkg_named_longer_than_any_user_name_27526 as
  function lf return varchar as begin return 'u1_27526.pkg_named_longer_than_any_user_name_27526.lf (package)'; end;
  procedure lp (r out varchar) as begin r := 'u1_27526.pkg_named_longer_than_any_user_name_27526.lp (package)'; end;
end;

-- the package pc27526 of u1_27526 and of u2_27526, for Case 22
create or replace package u1_27526.pc27526 as function cc return varchar; end;
create or replace package body u1_27526.pc27526 as
  function cc return varchar as begin return 'u1_27526.pc27526.cc (package)'; end;
end;
create or replace package u2_27526.pc27526 as function cc return varchar; end;
create or replace package body u2_27526.pc27526 as
  function cc return varchar as begin return 'u2_27526.pc27526.cc (package)'; end;
end;

-- the cases below run as u1_27526 unless they log in as another user
call login('u1_27526', '') on class db_user;
select cast ('' as varchar) into :h27526 from db_root;

-- an ambiguous name, a name that is not defined, and a procedure in an expression all fail with -494,
-- so the messages tell them apart; Case 23 also checks the DBMS_OUTPUT of dbms_output.put_line
--+ server-message on


evaluate 'Case 1: SELECT ux27526.ff () - two functions - is ambiguous';
select ux27526.ff () from db_root;

evaluate 'Case 2: CALL ux27526.ff () - two functions - is ambiguous';
call ux27526.ff ();

evaluate 'Case 3: SELECT ux27526.fp () calls the standalone function, not the package procedure';
select ux27526.fp () from db_root;

evaluate 'Case 4: CALL ux27526.fp () - a function and a procedure - is ambiguous';
call ux27526.fp ();

evaluate 'Case 5: SELECT ux27526.pf () calls the package function, not the standalone procedure';
select ux27526.pf () from db_root;

evaluate 'Case 6: CALL ux27526.pf (:h27526) - a procedure and a function - is ambiguous';
call ux27526.pf (:h27526);

evaluate 'Case 7: SELECT ux27526.pp () - two procedures - fails as a procedure in an expression';
select ux27526.pp () from db_root;

evaluate 'Case 8: CALL ux27526.pp (:h27526) - two procedures - is ambiguous';
call ux27526.pp (:h27526);


evaluate 'Case 9: ux27526.so () is a standalone routine only; result = ux27526.so (standalone)';
select ux27526.so () from db_root;


evaluate 'Case 10: ux27526.po () is a package function only, in the select list, WHERE, and a subquery';
select ux27526.po () from db_root;
select 'where' from db_root where ux27526.po () = 'u1_27526.ux27526.po (package)';
select (select ux27526.po () from db_root) from db_root;
select ux27526.pa (1), ux27526.pa (1, 2) from db_root;


evaluate 'Case 11: CALL of a package procedure, and of a package function with and without INTO';
call ux27526.pq (:h27526);
select :h27526 from db_root;
call ux27526.po ();
call ux27526.po () into :r27526;
select :r27526 from db_root;


evaluate 'Case 12: u1_27526.ux27526.<routine> is never ambiguous';
select u1_27526.ux27526.ff () from db_root;
select u1_27526.ux27526.pa (5) from db_root;
call u1_27526.ux27526.ff ();
call u1_27526.ux27526.fp (:h27526);
select :h27526 from db_root;
call u1_27526.ux27526.pp (:h27526);
select :h27526 from db_root;
-- a procedure in an expression still fails
select u1_27526.ux27526.pp () from db_root;


evaluate 'Case 13: a routine that does not exist fails';
select ux27526.nosuch () from db_root;
call ux27526.nosuch ();
select u1_27526.ux27526.nosuch () from db_root;
call u1_27526.ux27526.nosuch ();
select nosuchpkg27526.f () from db_root;


evaluate 'Case 14: a routine of a package without a body fails when it runs';
select nobody27526.f () from db_root;
call nobody27526.p ();


evaluate 'Case 15: g () and q () are the standalone routines of u1_27526, u1_27526.g () is ambiguous';
select g () from db_root;
call q (:h27526);
select :h27526 from db_root;
select u1_27526.g () from db_root;
call u1_27526.q (:h27526);
select u1_27526.u1_27526.g () from db_root;
call u1_27526.u1_27526.q (:h27526);
select :h27526 from db_root;


evaluate 'Case 16: a package name longer than a user name can be, in any letter case';
select pkg_named_longer_than_any_user_name_27526.lf () from db_root;
select PKG_NAMED_LONGER_THAN_ANY_USER_NAME_27526.LF () from db_root;
call pkg_named_longer_than_any_user_name_27526.lp (:h27526);
select :h27526 from db_root;
select pkg_named_longer_than_any_user_name_27526.lp () from db_root;
select pkg_named_longer_than_any_user_name_27526.nosuch () from db_root;


evaluate 'Case 17: a view reads its routine names again as the view owner u1_27526';
drop view if exists v_vs, v_vt, v_po;
create view v_vs as select uw27526.vs () as s from db_root;
create view v_vt as select uw27526.vt () as s from db_root;
create view v_po as select ux27526.po () as s from db_root;
grant select on v_vs to u2_27526;
grant select on v_vt to u2_27526;
grant select on v_po to u2_27526;
grant execute on package ux27526 to u2_27526;
select s from v_vs;
select s from v_vt;
select s from v_po;
-- a package uw27526 of the querier u2_27526 does not matter
call login('u2_27526', '') on class db_user;
create or replace package uw27526 as function vt return varchar; end;
create or replace package body uw27526 as
  function vt return varchar as begin return 'u2_27526.uw27526.vt (package)'; end;
end;
select s from u1_27526.v_vt;
select s from u1_27526.v_po;
-- a package uw27526 of the view owner makes uw27526.vs ambiguous, for the owner and for u2_27526
call login('u1_27526', '') on class db_user;
create or replace package uw27526 as function vs return varchar; end;
create or replace package body uw27526 as
  function vs return varchar as begin return 'u1_27526.uw27526.vs (package)'; end;
end;
select s from v_vs;
call login('u2_27526', '') on class db_user;
select s from u1_27526.v_vs;


evaluate 'Case 18: EXECUTE on the package is checked, and a routine not granted is still counted';
-- u2_27526 has EXECUTE on the package u1_27526.ux27526 since Case 17
select u1_27526.ux27526.po () from db_root;
call login('u1_27526', '') on class db_user;
revoke execute on package ux27526 from u2_27526;
call login('u2_27526', '') on class db_user;
select u1_27526.ux27526.po () from db_root;
-- ux27526.np is not granted to u2_27526, and it is ambiguous with the package ux27526 of u2_27526
create or replace package ux27526 as function np return varchar; end;
create or replace package body ux27526 as
  function np return varchar as begin return 'u2_27526.ux27526.np (package)'; end;
end;
select ux27526.np () from db_root;
select u2_27526.ux27526.np () from db_root;


evaluate 'Case 19: static SQL reads ux27526.po () as the owner u1_27526, also for u2_27526, and sf_amb fails to compile';
call login('u1_27526', '') on class db_user;
create or replace function sf_def return varchar as
  r varchar;
begin
  select ux27526.po () into r from db_root;
  return r;
end;
create or replace function sf_amb return varchar as
  r varchar;
begin
  select ux27526.ff () into r from db_root;
  return r;
end;
select sf_def () from db_root;
grant execute on procedure sf_def to u2_27526;
grant execute on package ux27526 to u2_27526;
call login('u2_27526', '') on class db_user;
select u1_27526.sf_def () from db_root;


evaluate 'Case 20: a package uz27526 created after sf_late makes uz27526.zf ambiguous when sf_late runs';
call login('u1_27526', '') on class db_user;
create or replace function sf_late return varchar as
  r varchar;
begin
  select uz27526.zf () into r from db_root;
  return r;
end;
select sf_late () from db_root;
create or replace package uz27526 as function zf return varchar; end;
create or replace package body uz27526 as
  function zf return varchar as begin return 'u1_27526.uz27526.zf (package)'; end;
end;
select sf_late () from db_root;


evaluate 'Case 21: h () in static SQL of the package body q27526 is the standalone h of u1_27526';
create or replace function h return varchar as begin return 'u1_27526.h (standalone)'; end;
create or replace package q27526 as
  function h return varchar;
  function call_h return varchar;
end;
create or replace package body q27526 as
  function h return varchar as begin return 'u1_27526.q27526.h (package)'; end;
  function call_h return varchar as
    r varchar;
  begin
    select h () into r from db_root;
    return r;
  end;
end;
select q27526.call_h () from db_root;


evaluate 'Case 22: pc27526.cc () run by u1_27526, u2_27526, and u1_27526 again calls the package of each';
select pc27526.cc () from db_root;
call login('u2_27526', '') on class db_user;
select pc27526.cc () from db_root;
call login('u1_27526', '') on class db_user;
select pc27526.cc () from db_root;


evaluate 'Case 23: dbms_output.put_line called by the user public is not ambiguous';
call login('public', '') on class db_user;
call dbms_output.put_line ('called by public');

--+ server-message off

call login('dba', '') on class db_user;

drop view u1_27526.v_vs, u1_27526.v_vt, u1_27526.v_po;
drop function u1_27526.sf_def, u1_27526.sf_late, u1_27526.h, u1_27526.g;
drop procedure u1_27526.q;
drop package u1_27526.ux27526;
drop package u1_27526.nobody27526;
drop package u1_27526.u1_27526;
drop package u1_27526.pkg_named_longer_than_any_user_name_27526;
drop package u1_27526.pc27526;
drop package u1_27526.uw27526;
drop package u1_27526.uz27526;
drop package u1_27526.q27526;
drop package u2_27526.pc27526;
drop package u2_27526.uw27526;
drop package u2_27526.ux27526;
drop function ux27526.ff, ux27526.fp, ux27526.so, ux27526.np;
drop procedure ux27526.pf, ux27526.pp;
drop function uw27526.vs, uw27526.vt, uz27526.zf;
drop user ux27526;
drop user uw27526;
drop user uz27526;
drop user u1_27526;
drop user u2_27526;

--+ holdcas off;
