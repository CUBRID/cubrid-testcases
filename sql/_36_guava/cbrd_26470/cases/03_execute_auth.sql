/**
 *  This test case verifies CBRD-26470: the EXECUTE authorization of a direct call from PL/CSQL
 *  is checked when the caller is compiled.
 *
 *  Calling another user's stored procedure or package routine directly without EXECUTE makes
 *  CREATE (the compile) of the caller fail, and after GRANT EXECUTE it succeeds. A call of the
 *  owner's own routine and a self-recursive call always pass. A Java SP is not checked at
 *  compile time (it is checked at run time by the server).
 *
 *  Coverage:
 *    Case 1: u03b -> u03a.f03_b without grant: EXECUTE authorization failure
 *    Case 2: owner u03a -> own f03_b: OK
 *    Case 3: self recursion of u03b.f03_rec: OK
 *    Case 4: after GRANT, u03b -> u03a.f03_b compiles and runs (expect 10)
 *    Case 5: u03b -> package routine u03a.pk03.pf without grant: EXECUTE authorization failure
 *    Case 6: u03b -> Java SP u03a.f03_j without grant: compile passes
 */

--+ server-message on

create user u03a;
create user u03b;

call login('u03a', '') on class db_user;
create or replace function f03_b(a int) return int as begin return a * 10; end;
create or replace package pk03 as function pf(a int) return int; end;
create or replace package body pk03 as function pf(a int) return int as begin return a + 1; end; end;
create or replace function f03_j(a int) return int as language java name 'Foo.bar(int) return int';


evaluate 'Case 1: u03b -> u03a.f03_b without grant, expect EXECUTE authorization failure';
call login('u03b', '') on class db_user;
create or replace function f03_a return int as begin return u03a.f03_b(1); end;


evaluate 'Case 2: owner u03a -> own f03_b, expect OK';
call login('u03a', '') on class db_user;
create or replace function f03_own return int as begin return f03_b(2); end;


evaluate 'Case 3: self recursion of u03b.f03_rec, expect OK';
call login('u03b', '') on class db_user;
create or replace function f03_rec(i int) return int as begin if i <= 0 then return 0; else return f03_rec(i - 1); end if; end;


evaluate 'Case 4: after GRANT, u03b -> u03a.f03_b compiles and runs, expect 10';
call login('u03a', '') on class db_user;
grant execute on procedure f03_b to u03b;
call login('u03b', '') on class db_user;
create or replace function f03_a return int as begin return u03a.f03_b(1); end;
select f03_a() from dual;


evaluate 'Case 5: u03b -> package routine u03a.pk03.pf without grant, expect EXECUTE authorization failure';
create or replace function f03_pkg return int as begin return u03a.pk03.pf(5); end;


evaluate 'Case 6: u03b -> Java SP u03a.f03_j without grant, expect OK (checked at run time)';
create or replace function f03_jsp return int as begin return u03a.f03_j(1); end;


call login('dba', '') on class db_user;
drop function u03b.f03_a, u03b.f03_rec, u03b.f03_jsp;
drop function u03a.f03_b, u03a.f03_own, u03a.f03_j;
drop package u03a.pk03;
drop user u03b;
drop user u03a;

--+ server-message off
