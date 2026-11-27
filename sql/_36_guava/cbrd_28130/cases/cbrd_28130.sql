/**
 *  This test case verifies CBRD-28130: BODY and PACKAGE, which the package feature added as
 *  keywords of SQL and PL/CSQL, and TYPE and RECORD, which it added as keywords of PL/CSQL, are
 *  non-reserved, so that tables, columns, variables, parameters and record fields with these names
 *  can be used without quotes again, as before the package feature.
 *
 *  CREATE PACKAGE BODY x AS creates the body of the package x, and CREATE PACKAGE body AS creates
 *  the spec of the package body. The saved code of a package or a routine with these names is
 *  compiled again without errors.
 *
 *  Coverage:
 *    Case 1: SQL - tables, columns, aliases, a view, a serial and an index named body or package
 *    Case 2: SQL - a table named package is altered, granted and dropped without the keyword TABLE
 *    Case 3: SQL - CREATE / ALTER / DROP PACKAGE [BODY], GRANT / REVOKE EXECUTE ON PACKAGE and
 *            the calls of package functions in SQL, also for the packages named body and package
 *    Case 4: PL/CSQL - variables and parameters named body, package, type and record, in
 *            expressions and as the host variables of static SQL
 *    Case 5: PL/CSQL - %TYPE of the columns named body and type, and the fields of a cursor
 *            record named body, package, type and record
 *    Case 6: PL/CSQL - package routines and parameters named body, package, type and record,
 *            called in PL/CSQL and in SQL
 *    Case 7: PL/CSQL - the saved code of a package named record and of a procedure with the
 *            parameters named body, package, record and type is compiled again
 *
 *    Case 3: known wrong result, CBRD-27526 (open)
 *    Case 3: known wrong result, CBRD-27527 (open)
 *    Case 6: known wrong result, CBRD-27526 (open)
 */

drop table if exists t28130, body, package, t28130_log;
drop view if exists v28130;
drop serial if exists package;
drop package if exists body;
drop package if exists package;
drop package if exists pk28130;
drop package if exists record;

create user u28130;


evaluate 'Case 1: SQL - tables, columns, aliases, a view, a serial and an index named body or package';
create table t28130 (body int, package int, type int, record int);
insert into t28130 (body, package, type, record) values (1, 2, 3, 4);
create table body (a int);
insert into body values (5);
select body, package, type, record from t28130;
select t28130.body, x.package from t28130, t28130 x where x.body = t28130.body;
select a as body, a package from body;
select body.a from body body where body.a > 0;
update t28130 set body = body + 10, package = package + 10;
select body, package from t28130 order by body, package;
create view v28130 (body, package) as select body, package from t28130;
select body, package from v28130;
create serial package;
select package.next_value;
create index body on t28130 (package);
select index_name from db_index where class_name = 't28130' and index_name = 'body';
drop index body on t28130;


evaluate 'Case 2: SQL - a table named package is altered, granted and dropped without the keyword TABLE';
create table package (a int);
alter package add column b int;
alter package comment = 'table package';
insert into package values (1, 2);
select package.a, package.b from package;
select class_name, comment from db_class where class_name = 'package';
grant select on package to u28130;
select grantee_name, object_name, auth_type from db_auth where grantee_name = 'U28130';
revoke select on package from u28130;
select count(*) from db_auth where grantee_name = 'U28130';
-- without the keyword PACKAGE after ON, package is the table package
grant execute on package to u28130;
select grantee_name, object_name, object_type, auth_type from db_auth where grantee_name = 'U28130';
revoke execute on package from u28130;
select count(*) from db_auth where grantee_name = 'U28130';
drop package;
select count(*) from db_class where class_name = 'package';


evaluate 'Case 3: SQL - CREATE / ALTER / DROP PACKAGE [BODY], GRANT / REVOKE EXECUTE ON PACKAGE and calls in SQL, also for the packages named body and package';
-- the spec of the package body, and then its body
create package body as
  function f return int;
end;
create package body body as
  function f return int is begin return 1; end;
end;
create or replace package package is
  function g return int;
end;
create or replace package body package is
  function g return int is begin return body.f () + 1; end;
end;
select pkg_name, spec_code, body_code from db_package_code where pkg_name in ('body', 'package') order by pkg_name;
create or replace function f28130 return int as begin return body.f () * 10 + package.g (); end;
select f28130 () from dual;
select body.f () as f, package.g () as g from dual;
grant execute on package body to u28130;
grant execute on package package to u28130;
select grantee_name, object_name, object_type, auth_type from db_auth where grantee_name = 'U28130' order by object_name;
revoke execute on package body from u28130;
revoke execute on package package from u28130;
select count(*) from db_auth where grantee_name = 'U28130';
alter package body compile;
alter package package compile;
alter package package comment 'package package';
-- the owner of body changes, not of package, because the body of package calls body.f, and u28130 has no EXECUTE on body
alter package body owner to u28130;
select pkg_name, owner, comment from db_package where pkg_name in ('body', 'package') order by pkg_name;
-- set the owner back so that the drops below, run by dba, find body
alter package u28130.body owner to dba;
select pkg_name, owner from db_package where pkg_name = 'body';
drop package body body;
select pkg_name, spec_code is not null as has_spec, body_code is not null as has_body from db_package_code
where pkg_name in ('body', 'package') order by pkg_name;
drop package body;
drop package body package;
drop package package;
select count(*) from db_package where pkg_name in ('body', 'package');
drop function f28130;


evaluate 'Case 4: PL/CSQL - variables and parameters named body, package, type and record';
create or replace function f28130_var return int as
  body int := 1;
  package int := 2;
  type int := 3;
  record constant int := 4;
begin
  return body * 1000 + package * 100 + type * 10 + record;
end;
select f28130_var () from dual;
create or replace function f28130_param (body int, package int, type int, record int) return int as
begin
  return body * 1000 + package * 100 + type * 10 + record;
end;
select f28130_param (4, 3, 2, 1) from dual;
create or replace function f28130_sql (p int) return int as
  body int;
  package int;
  type int;
  record int;
begin
  select t28130.body, t28130.package, t28130.type, t28130.record into body, package, type, record from t28130
  where t28130.type = p;
  return body * 1000 + package * 100 + type * 10 + record;
end;
select f28130_sql (3) from dual;
create or replace function f28130_sql2 return int as
  x int;
begin
  select body + package + type + record into x from t28130;
  return x;
end;
select f28130_sql2 () from dual;
create table t28130_log (n int);
create or replace procedure p28130_host (body int, package int) as
begin
  insert into t28130_log values (body + package);
end;
call p28130_host (20, 8);
select n from t28130_log;


evaluate 'Case 5: PL/CSQL - %TYPE of the columns named body and type, and the fields of a cursor record';
create or replace function f28130_ptype return varchar as
  x t28130.type%type := 3;
  y t28130.body%type := 5;
begin
  return x || ',' || y;
end;
select f28130_ptype () from dual;
create or replace function f28130_rec return int as
  cursor c is select body, package, type, record from t28130;
begin
  for r in c loop
    return r.body + r.package + r.type + r.record;
  end loop;
  return -1;
end;
select f28130_rec () from dual;
create or replace function f28130_rec2 return int as
begin
  for r in (select body as type, package as record from t28130) loop
    return r.type * 100 + r.record;
  end loop;
  return -1;
end;
select f28130_rec2 () from dual;


evaluate 'Case 6: PL/CSQL - package routines and parameters named body, package, type and record, called in PL/CSQL and SQL';
create or replace package pk28130 as
  function body (package int) return int;
  function type (record int) return int;
end;
create or replace package body pk28130 as
  function body (package int) return int is begin return package + 1; end;
  function type (record int) return int is begin return body (record) * 2; end;
end;
create or replace function f28130_pkg return int as begin return pk28130.body (41) * 1000 + pk28130.type (9); end;
select f28130_pkg () from dual;
select pk28130.body (41) as b, pk28130.type (9) as t from dual;


evaluate 'Case 7: PL/CSQL - the saved code of a package named record and of a procedure with the parameters body, package, record and type is compiled again';
-- CREATE PACKAGE BODY compiles the saved code of the spec again, and ALTER PROCEDURE COMPILE compiles the saved code of the procedure again
create or replace package record as
  function f return int;
end;
create or replace package body record as
  function f return int is begin return 3; end;
end;
select pkg_name, spec_code, body_code from db_package_code where pkg_name = 'record';
create or replace function f28130_pkg2 return int as begin return record.f (); end;
select f28130_pkg2 () from dual;
create or replace procedure p28130_rec (body int, package int, record int, type int) as
begin
  insert into t28130_log values (body * 1000 + package * 100 + record * 10 + type);
end;
alter procedure p28130_rec compile;
call p28130_rec (1, 2, 7, 1);
select n from t28130_log order by n;


drop function f28130_var;
drop function f28130_param;
drop function f28130_sql;
drop function f28130_sql2;
drop procedure p28130_host;
drop function f28130_ptype;
drop function f28130_rec;
drop function f28130_rec2;
drop function f28130_pkg;
drop function f28130_pkg2;
drop procedure p28130_rec;
drop package record;
drop package pk28130;
drop view v28130;
drop serial package;
drop table t28130, body, t28130_log;
drop user u28130;
