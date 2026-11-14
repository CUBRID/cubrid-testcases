/**
 *  This test case verifies CBRD-26470 (PR #7819): the run-time EXECUTE check of nested direct
 *  calls and the stack of execution rights.
 *
 *  Background:
 *    - A direct call site checks EXECUTE when it is first reached: checkExecuteAuthorization () ->
 *      CAS callback_handler::check_execute_auth () -> jsp_check_execute_authorization (). Au_user
 *      is then the owner of the calling routine (the definer pushed by
 *      METHOD_CALLBACK_CHANGE_EXEC_RIGHTS), not the session user. In
 *      u50low -> u50a.a1 -> u50b.b2 -> u50c.c3 the check of c3 is made as U50B. The grant of c3 to
 *      u50low does not matter. When it is revoked from u50b, the call must fail even when u50low has
 *      it (a package member follows the grant on the package).
 *    - When direct calls (rights switched on request of PL, executor::m_exec_rights_depth) and the
 *      SQL path (push/pop in execute () of a new executor) are mixed, the user stack of CAS must
 *      be pushed and popped correctly. After an inner call returns, the outer routine reads its
 *      own table with the rights of its owner.
 *
 *  Coverage:
 *    Case 1:  u50low: u50a.a1 (2) (a1 -> u50b.b2 -> u50c.c3, u50low has no grant on b2/c3) succeeds
 *    Case 2:  c3 granted to u50low and revoked from u50b: u50a.a1 (2) -> EXECUTE authorization failure
 *    Case 3:  control: u50c.c3 (2) by u50low itself (its own grant works) succeeds
 *    Case 4:  c3 granted back to u50b and revoked from u50low: u50a.a1 (2) succeeds again
 *    Case 5:  Case 1 with a package member (u50c.pkg50.pc): u50a.a1p (2) succeeds
 *    Case 6:  Case 2 with GRANT/REVOKE ON PACKAGE: EXECUTE authorization failure
 *    Case 7:  Case 3 with the package: the member is called from a function of u50low, since a
 *             package member cannot be called from SQL, and succeeds
 *    Case 8:  Case 4 with the package: u50a.a1p (2) succeeds again
 *    Case 9:  u50low: u50a.a1m () (a1m -direct-> u50b.b2m -SQL-> u50c.c3m -direct-> u50a.d1,
 *             each reads a table that only its owner can read) succeeds
 *    Case 10: u50low reads u50a.t50a after the call -> SELECT is not authorized
 *    Case 11: u50a.a1m () again gives the same result as in Case 9
 *    Case 12: current_user after the calls is U50LOW
 */

--+ server-message on

create user u50a;
create user u50b;
create user u50c;
create user u50low;

call login('u50a', '') on class db_user;
create table t50a (c int);
insert into t50a values (1);
create or replace function d1 return int as v int; begin select c into v from t50a; return v; end;
grant execute on procedure d1 to u50c;

call login('u50c', '') on class db_user;
create table t50c (c int);
insert into t50c values (3);
create or replace function c3 (n int) return int as begin return n + 1; end;
create or replace package pkg50 as function pc (n int) return int; end;
create or replace package body pkg50 as function pc (n int) return int as begin return n + 1; end; end;
grant execute on procedure c3 to u50b;
grant execute on package pkg50 to u50b;
create or replace function c3m return int as v int; w int;
begin
  v := u50a.d1 ();
  select c into w from t50c;
  return v * 100 + w;
end;
grant execute on procedure c3m to u50b;

call login('u50b', '') on class db_user;
create table t50b (c int);
insert into t50b values (2);
create or replace function b2 (n int) return int as begin return u50c.c3 (n) * 10; end;
create or replace function b2p (n int) return int as begin return u50c.pkg50.pc (n) * 10; end;
create or replace function b2m return int as v int; w int;
begin
  select u50c.c3m () into v from db_root;
  select c into w from t50b;
  return v * 10 + w;
end;
grant execute on procedure b2 to u50a;
grant execute on procedure b2p to u50a;
grant execute on procedure b2m to u50a;

call login('u50a', '') on class db_user;
create or replace function a1 (n int) return int as begin return u50b.b2 (n) + 1; end;
create or replace function a1p (n int) return int as begin return u50b.b2p (n) + 1; end;
create or replace function a1m return int as v int; w int;
begin
  v := u50b.b2m ();
  select c into w from t50a;
  return v * 10 + w;
end;
grant execute on procedure a1 to u50low;
grant execute on procedure a1p to u50low;
grant execute on procedure a1m to u50low;


evaluate 'Case 1: u50low -> u50a.a1 -> u50b.b2 -> u50c.c3 (u50low has no grant on b2/c3) -> 31';
call login('u50low', '') on class db_user;
select u50a.a1 (2) from db_root;


evaluate 'Case 2: c3 granted to u50low, revoked from u50b -> the c3 check is made as U50B: EXECUTE authorization failure';
call login('u50c', '') on class db_user;
grant execute on procedure c3 to u50low;
revoke execute on procedure c3 from u50b;
call login('u50low', '') on class db_user;
select u50a.a1 (2) from db_root;


evaluate 'Case 3: control - the own grant of u50low on c3 works -> 3';
select u50c.c3 (2) from db_root;


evaluate 'Case 4: c3 granted back to u50b, revoked from u50low -> 31';
call login('u50c', '') on class db_user;
grant execute on procedure c3 to u50b;
revoke execute on procedure c3 from u50low;
call login('u50low', '') on class db_user;
select u50a.a1 (2) from db_root;


evaluate 'Case 5: package - u50low -> u50a.a1p -> u50b.b2p -> u50c.pkg50.pc -> 31';
select u50a.a1p (2) from db_root;


evaluate 'Case 6: package - pkg50 granted to u50low, revoked from u50b -> EXECUTE authorization failure';
call login('u50c', '') on class db_user;
grant execute on package pkg50 to u50low;
revoke execute on package pkg50 from u50b;
call login('u50low', '') on class db_user;
select u50a.a1p (2) from db_root;


evaluate 'Case 7: package - control, the own grant of u50low on pkg50 works -> 3';
create or replace function lw50 return int as begin return u50c.pkg50.pc (2); end;
select lw50 () from db_root;


evaluate 'Case 8: package - pkg50 granted back to u50b, revoked from u50low -> 31';
call login('u50c', '') on class db_user;
grant execute on package pkg50 to u50b;
revoke execute on package pkg50 from u50low;
call login('u50low', '') on class db_user;
select u50a.a1p (2) from db_root;


evaluate 'Case 9: direct -> SQL -> direct, every level reads its own table -> 10321';
select u50a.a1m () from db_root;


evaluate 'Case 10: u50low itself cannot read u50a.t50a -> SELECT is not authorized';
select c from u50a.t50a;


evaluate 'Case 11: the same call again after the refused read -> 10321';
select u50a.a1m () from db_root;


evaluate 'Case 12: current_user after the calls -> U50LOW';
select current_user from db_root;


call login('dba', '') on class db_user;
drop function u50low.lw50;
drop function u50a.a1;
drop function u50a.a1p;
drop function u50a.a1m;
drop function u50a.d1;
drop function u50b.b2;
drop function u50b.b2p;
drop function u50b.b2m;
drop function u50c.c3;
drop function u50c.c3m;
drop package u50c.pkg50;
drop table u50a.t50a;
drop table u50b.t50b;
drop table u50c.t50c;
drop user u50low;
drop user u50a;
drop user u50b;
drop user u50c;

--+ server-message off
