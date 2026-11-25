/**
 *  This test case verifies CBRD-27428: the system views db_package and
 *  db_package_code.
 *
 *  db_package shows a row of _db_package and db_package_code a row of
 *  _db_package_code, with the owner name in place of the owner object and the
 *  package name without the owner. db_package leaves out system packages. A
 *  DBA group member, the owner and a member of the owner group see the rows of
 *  both views. A user with EXECUTE on the package, granted to the user, to a
 *  group of the user or to PUBLIC, sees only its db_package row.
 *
 *  Coverage:
 *    Case 1:  db_package has its ten columns with their types in order
 *    Case 2:  db_package_code has its four columns with their types in order
 *    Case 3:  the db_package row of pkg_full shows its column values and the times of _db_package
 *    Case 4:  db_package has no row for the system package dbms_output
 *    Case 5:  the db_package_code row of pkg_full holds its spec and body source
 *    Case 6:  a package with only a body has a db_package_code row and no db_package row
 *    Case 7:  a DBA group member sees pkg_full in both views
 *    Case 8:  the owner sees pkg_full in both views
 *    Case 9:  a member of the owner group sees pkg_full in both views
 *    Case 10: a user with EXECUTE sees pkg_full only in db_package
 *    Case 11: a user with no privilege sees pkg_full in neither view
 *    Case 12: after REVOKE EXECUTE the user no longer sees pkg_full in db_package
 *    Case 13: a member of a group with EXECUTE sees pkg_full only in db_package
 *    Case 14: with EXECUTE granted to PUBLIC, a user with no privilege of its own
 *             sees pkg_full only in db_package
 *    Case 15: a package with only a spec has a db_package row and a db_package_code
 *             row with body_code NULL
 */

--+ holdcas on;

evaluate 'Case 1: db_package has its ten columns with their types in order';
show columns from db_package;

evaluate 'Case 2: db_package_code has its four columns with their types in order';
show columns from db_package_code;

create user pkg_owner;
create user owner_member groups pkg_owner;
create user dba_member groups dba;
create user exec_grantee;
create user no_priv_user;
create user exec_group;
create user group_member groups exec_group;

call login('pkg_owner', '') on class db_user;
drop package if exists pkg_full;
drop package body if exists pkg_body_only;
drop package if exists pkg_spec_only;
create package pkg_full as
  procedure p (a int);
  function f (a int) return int;
end comment 'pkg_full comment';
-- the body comes 0.1 s after the spec, so that created_time and updated_time differ for Case 3
select sleep(0.1) from dual;
create package body pkg_full as
  procedure p (a int) as begin null; end;
  function f (a int) return int as begin return a; end;
end;
create package body pkg_body_only as
  procedure q as begin null; end;
end;
create package pkg_spec_only as
  procedure r;
end;
grant execute on package pkg_full to exec_grantee;

call login('dba', '') on class db_user;

evaluate 'Case 3: the db_package row of pkg_full shows its column values and the times of _db_package';
select v.pkg_name, v.owner, v.procedure_count, v.variable_count, v.exception_count, v.cursor_count, v.record_type_count, v.[comment],
       v.created_time = b.created_time as same_created_time,
       v.updated_time = b.updated_time as same_updated_time,
       b.created_time < b.updated_time as body_after_spec
from db_package v, _db_package b
where v.pkg_name = 'pkg_full' and b.pkg_name = 'pkg_full';

evaluate 'Case 4: db_package has no row for the system package dbms_output';
select pkg_name, flags % 2 as system_package from _db_package where pkg_name = 'dbms_output';
select count(*) from db_package where pkg_name = 'dbms_output';

evaluate 'Case 5: the db_package_code row of pkg_full holds its spec and body source';
select pkg_name, owner, spec_code, body_code from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 6: a package with only a body has a db_package_code row and no db_package row';
select pkg_name, owner, spec_code, body_code from db_package_code where pkg_name = 'pkg_body_only';
select count(*) from db_package where pkg_name = 'pkg_body_only';

evaluate 'Case 7: a DBA group member sees pkg_full in both views';
call login('dba_member', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select pkg_name, owner from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 8: the owner sees pkg_full in both views';
call login('pkg_owner', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select pkg_name, owner from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 9: a member of the owner group sees pkg_full in both views';
call login('owner_member', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select pkg_name, owner from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 10: a user with EXECUTE sees pkg_full only in db_package';
call login('exec_grantee', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select count(*) from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 11: a user with no privilege sees pkg_full in neither view';
call login('no_priv_user', '') on class db_user;
select count(*) from db_package where pkg_name = 'pkg_full';
select count(*) from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 12: after REVOKE EXECUTE the user no longer sees pkg_full in db_package';
call login('pkg_owner', '') on class db_user;
revoke execute on package pkg_full from exec_grantee;
call login('exec_grantee', '') on class db_user;
select count(*) from db_package where pkg_name = 'pkg_full';

evaluate 'Case 13: a member of a group with EXECUTE sees pkg_full only in db_package';
call login('pkg_owner', '') on class db_user;
grant execute on package pkg_full to exec_group;
call login('group_member', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select count(*) from db_package_code where pkg_name = 'pkg_full';

evaluate 'Case 14: with EXECUTE granted to PUBLIC, a user with no privilege of its own sees pkg_full only in db_package';
call login('pkg_owner', '') on class db_user;
-- every user is a member of PUBLIC, so this grant comes after Cases 11 and 12, which expect no db_package row
grant execute on package pkg_full to public;
call login('no_priv_user', '') on class db_user;
select pkg_name, owner from db_package where pkg_name = 'pkg_full';
select count(*) from db_package_code where pkg_name = 'pkg_full';

call login('dba', '') on class db_user;

evaluate 'Case 15: a package with only a spec has a db_package row and a db_package_code row with body_code NULL';
select pkg_name, owner, procedure_count from db_package where pkg_name = 'pkg_spec_only';
select pkg_name, owner, spec_code, body_code from db_package_code where pkg_name = 'pkg_spec_only';

drop package pkg_owner.pkg_full;
drop package pkg_owner.pkg_spec_only;
-- a package with only a body has no spec for DROP PACKAGE to find
drop package body pkg_owner.pkg_body_only;
drop user owner_member;
drop user dba_member;
drop user exec_grantee;
drop user no_priv_user;
drop user group_member;
drop user exec_group;
drop user pkg_owner;

--+ holdcas off;
