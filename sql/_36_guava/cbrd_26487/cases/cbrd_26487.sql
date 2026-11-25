/**
 *  This test case verifies CBRD-26487: unloaddb and loaddb include PL/CSQL packages.
 *
 *  A package spec and body are now saved in _db_package_code as
 *  CREATE OR REPLACE PACKAGE [BODY] [<name>] AS<text after AS or IS>, without the owner name and
 *  the comment, as stored procedures are saved. unloaddb then prints them with or without the
 *  owner name and adds the comment of _db_package. The name is quoted, and the text follows AS as
 *  it is, so that its lines keep their numbers (CBRD-27527). The white spaces after the text are
 *  dropped, so that the text does not grow each time it is saved again.
 *  The unload and the load themselves are checked by the shell TCs in
 *  shell/_40_guava/cbrd_26487 of cubrid-testcases-private-ex.
 *
 *  Coverage:
 *    Case 1:  DBA creates the spec of u26487.pk1 with the owner name and a comment - the spec is
 *             saved without them, and the comment is in _db_package
 *    Case 2:  DBA creates the body of u26487.pk1 with the owner name - the body is saved without it
 *    Case 3:  u26487 creates pk2 on one line without the owner name, with IS, the end label and a
 *             comment - the text after IS follows AS on the same line, and the end label is kept
 *    Case 4:  the saved specs and bodies, run again as they are by their owner, are saved the same
 *    Case 5:  a replace of the spec of pk1 with another comment saves the new spec and comment,
 *             and keeps the body and the grant
 *    Case 6:  a drop of the body of pk1 keeps the spec, the comment and the grant
 */

-- CTP trims each line and drops empty lines, so the saved code here has no indentation and no blank lines,
-- and the shell TC cbrd_26487_pkg_source checks how they are saved
drop table if exists t26487_code;

create user u26487;
create user u26487b;


evaluate 'Case 1: the spec is saved without the owner name and the comment';
create package u26487.pk1 as
  function a return int;
  function b (n int) return varchar;
end comment 'pk1 spec';
select pkg_unique_name, scode_spec, scode_body from _db_package_code where pkg_unique_name = 'u26487.pk1';
select unique_name, owner.name, comment from _db_package where unique_name = 'u26487.pk1';


evaluate 'Case 2: the body is saved without the owner name';
create package body u26487.pk1 as
  function a return int is
  begin
    return 1;
  end;
  function b (n int) return varchar is
  begin
    return 'b' || n;
  end;
end;
grant execute on package u26487.pk1 to u26487b;
select pkg_unique_name, scode_body from _db_package_code where pkg_unique_name = 'u26487.pk1';


evaluate 'Case 3: IS and the end label on one line, without the owner name';
call login('u26487', '') on class db_user;
create package pk2 is function c return int; end pk2 comment 'pk2 spec';
create package body pk2 is function c return int is begin return pk1.a () + 10; end; end pk2;
create function w26487 return varchar as
begin
  return pk1.b (pk1.a () * 100 + pk2.c ());
end;
select w26487 () from db_root;
call login('dba', '') on class db_user;
select pkg_unique_name, scode_spec, scode_body from _db_package_code where pkg_unique_name = 'u26487.pk2';
select unique_name, owner.name, comment from _db_package where unique_name = 'u26487.pk2';


-- the copy of the saved code before Case 4 runs it again
create table t26487_code as select pkg_unique_name, scode_spec, scode_body from _db_package_code
  where pkg_unique_name like 'u26487.%';

-- the statements below are the saved code that Case 1 to Case 3 print, run by u26487, the owner
evaluate 'Case 4: the saved code runs again and is saved the same; result = 2';
call login('u26487', '') on class db_user;
CREATE OR REPLACE PACKAGE [pk1] AS
function a return int;
function b (n int) return varchar;
end;
CREATE OR REPLACE PACKAGE BODY [pk1] AS
function a return int is
begin
return 1;
end;
function b (n int) return varchar is
begin
return 'b' || n;
end;
end;
CREATE OR REPLACE PACKAGE [pk2] AS function c return int; end pk2;
CREATE OR REPLACE PACKAGE BODY [pk2] AS function c return int is begin return pk1.a () + 10; end; end pk2;
select w26487 () from db_root;
call login('dba', '') on class db_user;
select count(*) from _db_package_code c, t26487_code t
  where c.pkg_unique_name = t.pkg_unique_name and c.scode_spec = t.scode_spec and c.scode_body = t.scode_body;


evaluate 'Case 5: a replace of the spec saves the new spec and comment, the body and the grant are kept';
create or replace package u26487.pk1 as
  FUNCTION a RETURN int;
  FUNCTION b (n int) RETURN varchar;
end comment 'pk1 spec 2';
select pkg_unique_name, scode_spec, scode_body from _db_package_code where pkg_unique_name = 'u26487.pk1';
select unique_name, comment from _db_package where unique_name = 'u26487.pk1';
select grantee_name, object_type, object_name, owner_name, auth_type from db_auth
  where object_name = 'pk1' and owner_name = 'U26487' order by grantee_name;
call login('u26487', '') on class db_user;
select w26487 () from db_root;
call login('dba', '') on class db_user;


evaluate 'Case 6: a drop of the body keeps the spec, the comment and the grant';
drop package body u26487.pk1;
select pkg_unique_name, scode_spec, scode_body from _db_package_code where pkg_unique_name = 'u26487.pk1';
select unique_name, comment from _db_package where unique_name = 'u26487.pk1';
select grantee_name, object_type, object_name, owner_name, auth_type from db_auth
  where object_name = 'pk1' and owner_name = 'U26487' order by grantee_name;


drop function u26487.w26487;
drop package u26487.pk2;
drop package u26487.pk1;
drop table t26487_code;
drop user u26487b;
drop user u26487;
