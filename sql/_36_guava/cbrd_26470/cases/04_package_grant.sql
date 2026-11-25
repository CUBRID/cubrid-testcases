/**
 *  This test case verifies CBRD-26470: GRANT / REVOKE EXECUTE ON PACKAGE.
 *
 *  EXECUTE on a package lets the grantee call the routines of the package (the owner always
 *  can). Before the grant and after the revoke, a direct call from PL/CSQL fails to compile with
 *  EXECUTE authorization failure.
 *
 *  Coverage:
 *    Case 1: u04b -> u04a.pk04.pf before grant: EXECUTE authorization failure
 *    Case 2: GRANT EXECUTE ON PACKAGE pk04 TO u04b: OK
 *    Case 3: after the grant, u04b -> u04a.pk04.pf compiles and runs,
 *            another routine u04a.pk04.pp is also callable
 *    Case 4: REVOKE EXECUTE ON PACKAGE pk04 FROM u04b: OK
 *    Case 5: after the revoke, a new caller fails with EXECUTE authorization failure
 *    Case 6: GRANT on a missing package: does not exist
 */

--+ server-message on

create user u04a;
create user u04b;

call login('u04a', '') on class db_user;
create or replace package pk04 as function pf(a int) return int; procedure pp(a int); end;
create or replace package body pk04 as
  function pf(a int) return int as begin return a + 1; end;
  procedure pp(a int) as begin null; end;
end;


evaluate 'Case 1: u04b -> u04a.pk04.pf before grant, expect EXECUTE authorization failure';
call login('u04b', '') on class db_user;
create or replace function f04_w return int as begin return u04a.pk04.pf(5); end;


evaluate 'Case 2: GRANT EXECUTE ON PACKAGE pk04 TO u04b, expect OK';
call login('u04a', '') on class db_user;
grant execute on package pk04 to u04b;


evaluate 'Case 3: after the grant, u04b -> u04a.pk04.pf compiles and runs (expect 6), u04a.pk04.pp also callable';
call login('u04b', '') on class db_user;
create or replace function f04_w return int as begin return u04a.pk04.pf(5); end;
select f04_w() from dual;
create or replace procedure p04_wp as begin u04a.pk04.pp(1); end;


evaluate 'Case 4: REVOKE EXECUTE ON PACKAGE pk04 FROM u04b, expect OK';
call login('u04a', '') on class db_user;
revoke execute on package pk04 from u04b;


evaluate 'Case 5: after the revoke, a new caller fails, expect EXECUTE authorization failure';
call login('u04b', '') on class db_user;
create or replace function f04_w3 return int as begin return u04a.pk04.pf(5); end;


evaluate 'Case 6: GRANT on a missing package, expect does not exist';
call login('u04a', '') on class db_user;
grant execute on package pk04_nosuch to u04b;


call login('dba', '') on class db_user;
drop function u04b.f04_w;
drop procedure u04b.p04_wp;
drop package u04a.pk04;
drop user u04b;
drop user u04a;

--+ server-message off
