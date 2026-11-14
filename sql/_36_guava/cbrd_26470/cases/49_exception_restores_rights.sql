/**
 *  This test case verifies CBRD-26470 (PR #7819): when an exception passes through direct calls
 *  of routines of other owners, the execution rights of every level are restored and the kind
 *  of the exception is kept.
 *
 *  Background:
 *    - When the owner differs, a direct call is made as pushExecRight (owner); try { invokeMethod }
 *      finally { popExecRight (); }. invokeMethod rethrows the exception of the callee as it is, so
 *      WHEN NO_DATA_FOUND / ZERO_DIVIDE / OTHERS of the caller gets the original exception, and with
 *      the POP in finally the handler runs with the rights of the owner of the caller. An exception
 *      that is not handled is reported at the call site in the caller.
 *    - The rights are checked by reading tables: only each owner can read its own table
 *      (u49a.t49a, u49b.t49b, u49c.t49c).
 *    - Call chains: u49low -> u49a.a1/a1h/a1nh -> u49b.b2/b2h (function direct call) -> u49c.c3
 *      (n=0 NO_DATA_FOUND, n=1 ZERO_DIVIDE)
 *      u49b -> u49b.cx/cy -> u49c.pe.chk (package procedure direct call, x<0 user-defined
 *      exception, x=0 ZERO_DIVIDE).
 *  (current_user in the routines is cut at the at sign so that the host name does not show.
 *   While package exceptions cannot be declared, e_bad of pe is a local exception of chk.)
 *  The DBMS_OUTPUT of the callee u49c.pe.chk in Cases 9 to 13 shows that the output of the
 *  callee reaches the caller in order, also for the statements that fail.
 *
 *  Coverage:
 *    Case 1:  u49a.a1 (0) -> NO_DATA_FOUND two levels down caught by a1, which reads u49a.t49a
 *    Case 2:  u49a.a1 (1) -> ZERO_DIVIDE two levels down caught by a1
 *    Case 3:  u49a.a1 (2) -> no exception, every level reads its own table
 *    Case 4:  u49a.a1h (0) -> b2h catches and reads u49b.t49b, a1h reads u49a.t49a
 *    Case 5:  u49a.a1nh (0) -> error with the positions in a1nh, b2 and c3, no data found
 *    Case 6:  current_user after that is U49LOW again
 *    Case 7:  u49low reads u49a.t49a -> SELECT is not authorized
 *    Case 8:  u49a.a1 (0) again in the same session gives the result of Case 1 (no rights depth leaked)
 *    Case 9:  u49b.cx (1) -> no exception, cx reads u49b.t49b
 *    Case 10: u49b.cx (-1) -> WHEN OTHERS with SQLCODE 1000 and the position in pe.chk, cx reads
 *             u49b.t49b
 *    Case 11: u49b.cx (0) -> WHEN ZERO_DIVIDE, cx reads u49b.t49b
 *    Case 12: u49b.cy (-1) -> error at the call site in cy and in chk: user defined exception
 *    Case 13: u49b.cy (0) -> error at the call site in cy and in chk: division by zero
 *    Case 14: current_user after that is U49B again
 *    Case 15: u49b reads u49c.t49c -> SELECT is not authorized
 */

--+ server-message on

create user u49a;
create user u49b;
create user u49c;
create user u49low;

call login('u49c', '') on class db_user;
create table t49c (c int);
insert into t49c values (3);
create or replace function c3 (n int) return int as v int;
begin
  if n = 0 then select c into v from t49c where c < 0; end if;
  if n = 1 then v := 1 / (n - 1); end if;
  select c into v from t49c;
  return v;
end;
create or replace package pe as procedure chk (x int); end;
create or replace package body pe as
  procedure chk (x int) as
    e_bad exception;
  begin
    dbms_output.put_line ('chk ' || x);
    if x < 0 then raise e_bad; end if;
    if x = 0 then dbms_output.put_line (1 / x); end if;
  end;
end;
grant execute on procedure c3 to u49b;
grant execute on package pe to u49b;

call login('u49b', '') on class db_user;
create table t49b (c int);
insert into t49b values (2);
create or replace function b2 (n int) return varchar as v int;
begin
  v := u49c.c3 (n);
  return 'b2:' || v;
end;
create or replace function b2h (n int) return varchar as v int; r varchar;
begin
  begin
    v := u49c.c3 (n);
    r := 'noexc';
  exception
    when others then r := 'b2h-caught';
  end;
  select c into v from t49b;
  return r || ':' || v;
end;
create or replace function cx (x int) return varchar as n int;
begin
  u49c.pe.chk (x);
  select c into n from t49b;
  return 'ok ' || substring_index(current_user, '@', 1) || ' ' || n;
exception
  when zero_divide then
    select c into n from t49b;
    return 'caught zd ' || substring_index(current_user, '@', 1) || ' ' || n;
  when others then
    select c into n from t49b;
    return 'caught others ' || sqlcode || ' ' || sqlerrm || ' ' || substring_index(current_user, '@', 1) || ' ' || n;
end;
create or replace function cy (x int) return varchar as
begin
  u49c.pe.chk (x);
  return 'ok';
end;
grant execute on procedure b2 to u49a;
grant execute on procedure b2h to u49a;

call login('u49a', '') on class db_user;
create table t49a (c int);
insert into t49a values (1);
create or replace function a1 (n int) return varchar as v int; r varchar;
begin
  begin
    r := u49b.b2 (n);
  exception
    when no_data_found then r := 'ndf';
    when zero_divide then r := 'zd';
  end;
  select c into v from t49a;
  return r || ':' || v;
end;
create or replace function a1h (n int) return varchar as v int; r varchar;
begin
  r := u49b.b2h (n);
  select c into v from t49a;
  return r || '|' || v;
end;
create or replace function a1nh (n int) return varchar as
begin
  return u49b.b2 (n);
end;
grant execute on procedure a1 to u49low;
grant execute on procedure a1h to u49low;
grant execute on procedure a1nh to u49low;


call login('u49low', '') on class db_user;

evaluate 'Case 1: u49a.a1 (0) -> ndf:1 (NO_DATA_FOUND two levels down caught by a1, a1 reads u49a.t49a)';
select u49a.a1 (0);


evaluate 'Case 2: u49a.a1 (1) -> zd:1 (ZERO_DIVIDE two levels down caught by a1)';
select u49a.a1 (1);


evaluate 'Case 3: u49a.a1 (2) -> b2:3:1 (no exception)';
select u49a.a1 (2);


evaluate 'Case 4: u49a.a1h (0) -> b2h-caught:2|1 (b2h reads u49b.t49b, a1h reads u49a.t49a)';
select u49a.a1h (0);


evaluate 'Case 5: u49a.a1nh (0) -> error at the positions in a1nh, b2 and c3: no data found';
select u49a.a1nh (0);


evaluate 'Case 6: current_user after the exceptions -> U49LOW';
select current_user;


evaluate 'Case 7: u49low itself cannot read u49a.t49a -> SELECT is not authorized';
select c from u49a.t49a;


evaluate 'Case 8: the same call again in the session (no rights depth leaked) -> ndf:1#again';
select u49a.a1 (0) || '#again';


call login('u49b', '') on class db_user;

-- the DBMS_OUTPUT of chk in Cases 9 to 13 shows the order of the calls of the callee
evaluate 'Case 9: u49b.cx (1) -> ok U49B 2';
select cx (1);


evaluate 'Case 10: u49b.cx (-1) -> caught others 1000 ... (line 6, column 19) user defined exception U49B 2';
select cx (-1);


evaluate 'Case 11: u49b.cx (0) -> caught zd U49B 2';
select cx (0);


evaluate 'Case 12: u49b.cy (-1) -> error at the call site of cy and in chk: user defined exception';
select cy (-1);


evaluate 'Case 13: u49b.cy (0) -> error at the call site of cy and in chk: division by zero';
select cy (0);


evaluate 'Case 14: current_user after the exceptions -> U49B';
select current_user;



evaluate 'Case 15: u49b itself cannot read u49c.t49c -> SELECT is not authorized';
select c from u49c.t49c;


call login('dba', '') on class db_user;
drop function u49a.a1;
drop function u49a.a1h;
drop function u49a.a1nh;
drop function u49b.b2;
drop function u49b.b2h;
drop function u49b.cx;
drop function u49b.cy;
drop function u49c.c3;
drop package u49c.pe;
drop table u49a.t49a;
drop table u49b.t49b;
drop table u49c.t49c;
drop user u49low;
drop user u49a;
drop user u49b;
drop user u49c;

--+ server-message off
