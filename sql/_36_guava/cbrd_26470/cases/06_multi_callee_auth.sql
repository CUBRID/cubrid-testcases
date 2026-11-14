/**
 *  This test case verifies CBRD-26470: run-time EXECUTE checks of a caller that directly calls
 *  routines of two different packages are independent of each other.
 *
 *  Each callee package has its own slot in the authorization flags of the caller. Revoking EXECUTE on
 *  one package denies the callers of that package only; a caller of the other package still runs.
 *
 *  Coverage:
 *    Case 1: u06b compiles a caller of both u06a.pk06a and u06c.pk06b: OK
 *    Case 2: the caller runs and adds the values of both callees
 *    Case 3: after revoking only pk06b, the caller fails at run time: authorization failure
 *    Case 4: a caller of only pk06a still runs
 */

--+ server-message on

create user u06a;
create user u06b;
create user u06c;

call login('u06a', '') on class db_user;
create or replace package pk06a as function pf(a int) return int; end;
create or replace package body pk06a as function pf(a int) return int as begin return a + 100; end; end;
grant execute on package pk06a to u06b;

call login('u06c', '') on class db_user;
create or replace package pk06b as function pg(a int) return int; end;
create or replace package body pk06b as function pg(a int) return int as begin return a + 200; end; end;
grant execute on package pk06b to u06b;


evaluate 'Case 1: u06b compiles a caller of both packages, expect OK';
call login('u06b', '') on class db_user;
create or replace function u06b.f06_both return int as begin return u06a.pk06a.pf(1) + u06c.pk06b.pg(1); end;


evaluate 'Case 2: the caller runs, expect 302';
select f06_both() from dual;


evaluate 'Case 3: after revoking only pk06b, the caller fails at run time, expect authorization failure';
call login('u06c', '') on class db_user;
revoke execute on package pk06b from u06b;
call login('u06b', '') on class db_user;
select f06_both() from dual;


evaluate 'Case 4: a caller of only pk06a still runs, expect 101';
create or replace function u06b.f06_a return int as begin return u06a.pk06a.pf(1); end;
select f06_a() from dual;


call login('dba', '') on class db_user;
drop function u06b.f06_both, u06b.f06_a;
drop package u06a.pk06a;
drop package u06c.pk06b;
drop user u06b;
drop user u06a;
drop user u06c;

--+ server-message off
