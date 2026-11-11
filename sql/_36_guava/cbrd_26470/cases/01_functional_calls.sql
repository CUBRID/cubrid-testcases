/**
 *  This test case verifies CBRD-26470: direct calls between PL/CSQL units, and the compile_id
 *  kept in the code catalogs (_db_stored_procedure_code / _db_package_code).
 *
 *  A PL/CSQL routine now calls another stored procedure or a package routine directly instead
 *  of going through SQL. Package routines cannot be called from SQL, so their results are seen
 *  through standalone wrapper functions.
 *
 *  The compile_id of a routine lives in its code row and is reached through the 'code' reference
 *  of the owning row. It must be set when the routine is created and must change whenever the
 *  code changes: CREATE OR REPLACE of a stored procedure, and of a package spec or body, and
 *  DROP PACKAGE BODY. The values change at every run, so only comparisons are printed.
 *
 *  Coverage:
 *    Case 1: SP -> SP direct call (expect 12)
 *    Case 2: package routine -> standalone SP (expect 51)
 *    Case 3: package routine -> package routine of another package (expect 102)
 *    Case 4: direct call of a procedure with an OUT argument (expect 23)
 *    Case 5: compile_id of an SP is set on create and changes on replace
 *    Case 6: compile_id of a package is set on spec create and changes on spec replace,
 *            body create, body replace and body drop
 *    Case 7: DROP PACKAGE removes the package row
 */

--+ server-message on

drop package if exists pk01_a;
drop package if exists pk01_b;
drop package if exists pk01_c;
drop package if exists pk01_cid;
drop table if exists t01_cid;


evaluate 'Case 1: SP -> SP direct call, expect 12';
create or replace function f01_add_one(n int) return int as
begin
  return n + 1;
end;
create or replace function f01_add_two(n int) return int as
begin
  return f01_add_one(f01_add_one(n));
end;
select f01_add_two(10) as result from dual;


evaluate 'Case 2: package routine -> standalone SP, expect 51';
create or replace function f01_ext(n int) return int as
begin
  return n * 10;
end;
create or replace package pk01_a as
  function pf(n int) return int;
end;
create or replace package body pk01_a as
  function pf(n int) return int as
  begin
    return f01_ext(n) + 1;
  end;
end;
create or replace function f01_w_pkg_to_sp(n int) return int as
begin
  return pk01_a.pf(n);
end;
select f01_w_pkg_to_sp(5) as result from dual;


evaluate 'Case 3: package routine -> package routine of another package, expect 102';
create or replace package pk01_b as
  function bf(n int) return int;
end;
create or replace package body pk01_b as
  function bf(n int) return int as
  begin
    return n + 100;
  end;
end;
create or replace package pk01_c as
  function cf(n int) return int;
end;
create or replace package body pk01_c as
  function cf(n int) return int as
  begin
    return pk01_b.bf(n) + 1;
  end;
end;
create or replace function f01_w_pkg_to_pkg(n int) return int as
begin
  return pk01_c.cf(n);
end;
select f01_w_pkg_to_pkg(1) as result from dual;


evaluate 'Case 4: direct call of a procedure with an OUT argument, expect 23';
create or replace procedure p01_set_double(i in int, o out int) as
begin
  o := i * 2;
end;
create or replace function f01_use_out(n int) return int as
  v int;
begin
  p01_set_double(n, v);
  return v + 3;
end;
select f01_use_out(10) as result from dual;


evaluate 'Case 5: compile_id of an SP is set on create (1) and changes on replace (1)';
create table t01_cid (step int, cid varchar);
create or replace function f01_cid(n int) return int as begin return n; end;
insert into t01_cid select 1, code.compile_id from _db_stored_procedure where sp_name = 'f01_cid';
create or replace function f01_cid(n int) return int as begin return n + 1; end;
insert into t01_cid select 2, code.compile_id from _db_stored_procedure where sp_name = 'f01_cid';
select (select count(*) from t01_cid where step = 1 and cid is not null) as set_on_create,
       (select count(*) from t01_cid a, t01_cid b where a.step = 1 and b.step = 2 and a.cid <> b.cid) as changed_on_replace
from dual;


evaluate 'Case 6: compile_id of a package is set on spec create and changes at every step below, expect all 1';
delete from t01_cid;
create or replace package pk01_cid as function f(n int) return int; end;
insert into t01_cid select 1, code.compile_id from _db_package where pkg_name = 'pk01_cid';
create or replace package pk01_cid as function f(n int) return int; procedure p; end;
insert into t01_cid select 2, code.compile_id from _db_package where pkg_name = 'pk01_cid';
create or replace package body pk01_cid as function f(n int) return int as begin return n; end; procedure p as begin null; end; end;
insert into t01_cid select 3, code.compile_id from _db_package where pkg_name = 'pk01_cid';
create or replace package body pk01_cid as function f(n int) return int as begin return n + 1; end; procedure p as begin null; end; end;
insert into t01_cid select 4, code.compile_id from _db_package where pkg_name = 'pk01_cid';
drop package body pk01_cid;
insert into t01_cid select 5, code.compile_id from _db_package where pkg_name = 'pk01_cid';
select (select count(*) from t01_cid where step = 1 and cid is not null) as set_on_spec_create,
       (select count(*) from t01_cid a, t01_cid b where a.step = 1 and b.step = 2 and a.cid <> b.cid) as spec_replace,
       (select count(*) from t01_cid a, t01_cid b where a.step = 2 and b.step = 3 and a.cid <> b.cid) as body_create,
       (select count(*) from t01_cid a, t01_cid b where a.step = 3 and b.step = 4 and a.cid <> b.cid) as body_replace,
       (select count(*) from t01_cid a, t01_cid b where a.step = 4 and b.step = 5 and a.cid <> b.cid) as body_drop
from dual;


evaluate 'Case 7: DROP PACKAGE removes the package row, expect 0';
drop package pk01_cid;
select count(*) from _db_package where pkg_name = 'pk01_cid';


drop function f01_add_one, f01_add_two, f01_ext, f01_w_pkg_to_sp, f01_w_pkg_to_pkg, f01_use_out, f01_cid;
drop procedure p01_set_double;
drop package pk01_a;
drop package pk01_b;
drop package pk01_c;
drop table t01_cid;

--+ server-message off
