-- CBRD-27782: the server switches the execution rights of a DEFINER stored routine (push/pop of the owner) on the
-- client and now waits for the client to finish the switch. Check that the rights are switched and restored right:
-- lowu calls routines owned by u4, and only u4 can read u4.t.

evaluate 'setup: u4 owns table t and the routines; lowu may only execute them';
create user lowu;
create user u4;
create table nums (n int);
insert into nums select rownum from db_class a, db_class b, db_class c where rownum <= 4000;
create table dst (n int, v int);
grant select on nums to lowu;
grant insert, select on dst to lowu;

call login('u4','') on class db_user;
create table t (c int);
insert into t values (4);

create or replace function f_def return varchar as
  v int;
  u varchar;
begin
  select c into v from t;
  select current_user into u from db_root;
  return u || ':' || v;
end;

create or replace function f_err return int as
  v int;
begin
  select c into v from t;
  if v > 0 then
    raise_application_error (1001, 'error from f_err');
  end if;
  return v;
end;

create or replace function f_plus (n int) return int as
  v int;
begin
  select c into v from t;
  return n + v;
end;

grant execute on procedure f_def to lowu;
grant execute on procedure f_err to lowu;
grant execute on procedure f_plus to lowu;
grant execute on procedure f_def to dba;

call login('dba','') on class db_user;
create or replace function outer_f return varchar as
begin
  return 'outer:' || u4.f_def ();
end;
create or replace function f_same return varchar as
  u varchar;
begin
  select current_user into u from db_root;
  return u;
end;
grant execute on procedure outer_f to lowu;

call login('lowu','') on class db_user;

evaluate '1. a DEFINER function runs as its owner: U4:4';
select u4.f_def () from db_root;
evaluate '1. the session user is LOWU again';
select current_user from db_root;

evaluate '2. a DEFINER function raises an error: the error is returned';
select u4.f_err () from db_root;
evaluate '2. the rights are restored after the error: LOWU';
select current_user from db_root;

evaluate '3. nested: dba.outer_f (as DBA) calls u4.f_def (as U4): outer:U4:4';
select dba.outer_f () from db_root;
evaluate '3. the session user is LOWU';
select current_user from db_root;

evaluate '4. 4000 calls in one statement switch the rights 8000 times: 4000 rows, sum of (v - n) is 16000';
insert into dba.dst select n, u4.f_plus (n) from dba.nums;
select count(*), sum (v - n) from dba.dst;
evaluate '4. the session user is LOWU';
select current_user from db_root;

evaluate '5. lowu still cannot read u4.t directly: error';
select c from u4.t;

call login('dba','') on class db_user;
evaluate '6. the owner calls its own function: DBA, and the session user is DBA';
select f_same () from db_root;
select current_user from db_root;

evaluate 'cleanup';
drop function outer_f;
drop function f_same;
drop table dst;
drop table nums;
call login('u4','') on class db_user;
drop function f_def;
drop function f_err;
drop function f_plus;
drop table t;
call login('dba','') on class db_user;
drop user lowu;
drop user u4;
