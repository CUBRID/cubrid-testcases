/**
 *  This test case verifies CBRD-26470: the EXECUTE authorization check on the SQL CALL path.
 *
 *  The purpose argument of jsp_find_stored_procedure was removed and the check moved to its only
 *  user, jsp_make_pl_signature. The check must still work: CALL of another user's routine needs
 *  EXECUTE, the owner can always call it, a package routine follows the grant of its package,
 *  and a Java SP (not checked at compile time) relies on this check only.
 *
 *  Coverage:
 *    Case 1: CALL u08a.f08_b by u08b without grant: authorization failure
 *    Case 2: CALL f08_b by the owner (expect 30)
 *    Case 3: after GRANT, CALL u08a.f08_b by u08b (expect 30)
 *    Case 4: after REVOKE, CALL u08a.f08_b by u08b: authorization failure
 *    Case 5: after GRANT ON PACKAGE, u08b calls u08a.pk08.pf through a wrapper (expect 2)
 *    Case 6: CALL Java SP u08a.f08_j by u08b without grant: authorization failure
 */

--+ server-message on

create user u08a;
create user u08b;

call login('u08a', '') on class db_user;
create or replace function f08_b(a int) return int as begin return a * 10; end;
create or replace package pk08 as function pf(a int) return int; end;
create or replace package body pk08 as function pf(a int) return int as begin return a + 1; end; end;
create or replace function f08_j(a int) return int as language java name 'Foo.bar(int) return int';


evaluate 'Case 1: CALL u08a.f08_b by u08b without grant, expect authorization failure';
call login('u08b', '') on class db_user;
call u08a.f08_b(3);


evaluate 'Case 2: CALL f08_b by the owner, expect 30';
call login('u08a', '') on class db_user;
call f08_b(3);


evaluate 'Case 3: after GRANT, CALL u08a.f08_b by u08b, expect 30';
grant execute on procedure f08_b to u08b;
call login('u08b', '') on class db_user;
call u08a.f08_b(3);


evaluate 'Case 4: after REVOKE, CALL u08a.f08_b by u08b, expect authorization failure';
call login('u08a', '') on class db_user;
revoke execute on procedure f08_b from u08b;
call login('u08b', '') on class db_user;
call u08a.f08_b(3);


evaluate 'Case 5: after GRANT ON PACKAGE, u08b calls u08a.pk08.pf through a wrapper, expect 2';
call login('u08a', '') on class db_user;
grant execute on package pk08 to u08b;
call login('u08b', '') on class db_user;
create or replace function f08_w_pk return int as begin return u08a.pk08.pf(1); end;
select f08_w_pk() as r from dual;


evaluate 'Case 6: CALL Java SP u08a.f08_j by u08b without grant, expect authorization failure';
call u08a.f08_j(3);


call login('dba', '') on class db_user;
drop function u08b.f08_w_pk;
drop function u08a.f08_b, u08a.f08_j;
drop package u08a.pk08;
drop user u08b;
drop user u08a;

--+ server-message off
