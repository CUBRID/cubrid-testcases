/**
 *  This test case verifies CBRD-26470: EXECUTE authorization when the callee of a direct call
 *  is a package routine.
 *
 *  The owner and DBA can always call it. Another user is denied at compile time without the
 *  grant, allowed after GRANT EXECUTE ON PACKAGE, and denied again after REVOKE. EXECUTE is also
 *  checked again at run time, so a caller compiled while the grant was there is denied after
 *  the revoke without being recompiled.
 *
 *  Coverage:
 *    Case 1: owner u05a calls its own package routine: OK
 *    Case 2: DBA calls the package routine of u05a without grant: OK
 *    Case 3: u05b without grant calls u05a.pk05.pf / u05a.pk05.pp: authorization failure
 *    Case 4: after GRANT, u05b compiles and runs callers
 *    Case 5: after REVOKE, a new caller of u05b fails: authorization failure
 *    Case 6: a caller compiled with the grant runs, and after REVOKE fails at run time
 *    Case 7: repeated GRANT / REVOKE: compile OK after grant, authorization failure after revoke
 */

--+ server-message on

create user u05a;
create user u05b;

call login('u05a', '') on class db_user;
create or replace package pk05 as function pf(a int) return int; procedure pp(a int); end;
create or replace package body pk05 as
  function pf(a int) return int as begin return a + 1; end;
  procedure pp(a int) as begin null; end;
end;


evaluate 'Case 1: owner u05a calls its own package routine, expect OK';
create or replace function u05a.f05_own return int as begin return u05a.pk05.pf(5); end;


evaluate 'Case 2: DBA calls u05a package routine without grant, expect OK';
call login('dba', '') on class db_user;
create or replace function dba.f05_dba return int as begin return u05a.pk05.pf(5); end;


evaluate 'Case 3: u05b without grant calls u05a.pk05.pf / u05a.pk05.pp, expect authorization failure twice';
call login('u05b', '') on class db_user;
create or replace function u05b.f05_w return int as begin return u05a.pk05.pf(5); end;
create or replace procedure u05b.p05_w as begin u05a.pk05.pp(1); end;


evaluate 'Case 4: after GRANT, u05b compiles and runs callers, expect 6';
call login('u05a', '') on class db_user;
grant execute on package pk05 to u05b;
call login('u05b', '') on class db_user;
create or replace function u05b.f05_w return int as begin return u05a.pk05.pf(5); end;
select f05_w() from dual;
create or replace procedure u05b.p05_w as begin u05a.pk05.pp(1); end;


evaluate 'Case 5: after REVOKE, a new caller of u05b fails, expect authorization failure';
call login('u05a', '') on class db_user;
revoke execute on package pk05 from u05b;
call login('u05b', '') on class db_user;
create or replace function u05b.f05_w2 return int as begin return u05a.pk05.pf(5); end;


evaluate 'Case 6: a caller compiled with the grant runs (expect 8), and after REVOKE fails at run time';
call login('u05a', '') on class db_user;
grant execute on package pk05 to u05b;
call login('u05b', '') on class db_user;
create or replace function u05b.f05_keep return int as begin return u05a.pk05.pf(7); end;
select f05_keep() from dual;
call login('u05a', '') on class db_user;
revoke execute on package pk05 from u05b;
call login('u05b', '') on class db_user;
select f05_keep() from dual;


evaluate 'Case 7: repeated GRANT / REVOKE, expect compile OK after grant and authorization failure after revoke';
call login('u05a', '') on class db_user;
grant execute on package pk05 to u05b;
call login('u05b', '') on class db_user;
create or replace function u05b.f05_w3 return int as begin return u05a.pk05.pf(1); end;
call login('u05a', '') on class db_user;
revoke execute on package pk05 from u05b;
call login('u05b', '') on class db_user;
create or replace function u05b.f05_w4 return int as begin return u05a.pk05.pf(1); end;


call login('dba', '') on class db_user;
drop function dba.f05_dba;
drop function u05b.f05_w, u05b.f05_keep, u05b.f05_w3;
drop procedure u05b.p05_w;
drop function u05a.f05_own;
drop package u05a.pk05;
drop user u05b;
drop user u05a;

--+ server-message off
