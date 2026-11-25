/**
 *  This test case verifies CBRD-27296: SHOW GRANTS shows the EXECUTE privileges on packages.
 *
 *  SHOW GRANTS FOR a user lists the EXECUTE privileges granted by GRANT EXECUTE ON PACKAGE as
 *  GRANT EXECUTE ON PACKAGE <owner>.<package> TO <grantee>, as it lists those on tables and procedures.
 *  It lists the privileges granted to the user and to the groups of the user, PUBLIC included,
 *  and leaves out system packages.
 *
 *  Coverage:
 *    Case 1:  EXECUTE on a table, a procedure and a package granted to a user: one line each,
 *             the package line with PACKAGE after ON
 *    Case 2:  a package with only a spec and a package of another owner are listed,
 *             each with its owner and its name in lowercase
 *    Case 3:  the user gets the same lines from SHOW GRANTS and SHOW GRANTS FOR CURRENT_USER
 *    Case 4:  EXECUTE granted to a group is listed for the group and for its member, with the group as the grantee
 *    Case 5:  EXECUTE granted to PUBLIC is listed for PUBLIC and for a user, with PUBLIC as the grantee,
 *             and no longer after REVOKE
 *    Case 6:  WITH GRANT OPTION on a package is refused, and no line has WITH GRANT OPTION
 *    Case 7:  EXECUTE on the system package dbms_output is in _db_auth but not listed
 *    Case 8:  after CREATE OR REPLACE PACKAGE the line of the package is still listed
 *    Case 9:  after REVOKE the line of the package is gone and the other lines remain
 *    Case 10: after DROP PACKAGE the lines of the package are gone
 */

--+ holdcas on;

create user sg_owner;
create user sg_user;
create user sg_group;
create user sg_member groups sg_group;

call login('sg_owner', '') on class db_user;
create table sg_tbl (a int);
create procedure sg_proc () as begin null; end;
create package sg_pkg as
  procedure p;
end;
create package body sg_pkg as
  procedure p as begin null; end;
end;
create package sg_pkg_spec as
  procedure q;
end;

evaluate 'Case 1: EXECUTE on a table, a procedure and a package granted to a user: one line each, the package line with PACKAGE after ON';
grant select on sg_tbl to sg_user;
grant execute on procedure sg_proc to sg_user;
grant execute on package sg_pkg to sg_user;
call login('dba', '') on class db_user;
show grants for sg_user;

evaluate 'Case 2: a package with only a spec and a package of another owner are listed, each with its owner and its name in lowercase';
create package Sg_Dba_Pkg as
  procedure r;
end;
grant execute on package Sg_Dba_Pkg to sg_user;
call login('sg_owner', '') on class db_user;
grant execute on package sg_pkg_spec to sg_user;
call login('dba', '') on class db_user;
show grants for sg_user;

evaluate 'Case 3: the user gets the same lines from SHOW GRANTS and SHOW GRANTS FOR CURRENT_USER';
call login('sg_user', '') on class db_user;
show grants;
show grants for current_user;
call login('dba', '') on class db_user;

evaluate 'Case 4: EXECUTE granted to a group is listed for the group and for its member, with the group as the grantee';
call login('sg_owner', '') on class db_user;
grant select on sg_tbl to sg_group;
grant execute on package sg_pkg to sg_group;
call login('dba', '') on class db_user;
show grants for sg_group;
show grants for sg_member;

evaluate 'Case 5: EXECUTE granted to PUBLIC is listed for PUBLIC and for a user, with PUBLIC as the grantee, and no longer after REVOKE';
call login('sg_owner', '') on class db_user;
grant select on sg_tbl to public;
grant execute on package sg_pkg_spec to public;
call login('dba', '') on class db_user;
show grants for public;
show grants for sg_member;
call login('sg_owner', '') on class db_user;
revoke select on sg_tbl from public;
revoke execute on package sg_pkg_spec from public;
call login('dba', '') on class db_user;
show grants for public;
show grants for sg_member;

evaluate 'Case 6: WITH GRANT OPTION on a package is refused, and no line has WITH GRANT OPTION';
call login('sg_owner', '') on class db_user;
grant execute on package sg_pkg to sg_user with grant option;
call login('dba', '') on class db_user;
show grants for sg_user;

evaluate 'Case 7: EXECUTE on the system package dbms_output is in _db_auth but not listed';
grant execute on package public.dbms_output to sg_user;
select p.unique_name, p.flags % 2 as system_package, a.auth_type
from _db_auth a, _db_package p
where a.object_of = p and a.object_type = 6 and a.grantee.name = 'SG_USER' and p.pkg_name = 'dbms_output';
show grants for sg_user;

evaluate 'Case 8: after CREATE OR REPLACE PACKAGE the line of the package is still listed';
call login('sg_owner', '') on class db_user;
create or replace package sg_pkg_spec as
  procedure q;
  procedure q2;
end;
call login('dba', '') on class db_user;
show grants for sg_user;

evaluate 'Case 9: after REVOKE the line of the package is gone and the other lines remain';
call login('sg_owner', '') on class db_user;
revoke execute on package sg_pkg from sg_user;
call login('dba', '') on class db_user;
show grants for sg_user;
show grants for sg_group;

evaluate 'Case 10: after DROP PACKAGE the lines of the package are gone';
drop package sg_owner.sg_pkg;
drop package sg_owner.sg_pkg_spec;
show grants for sg_user;
show grants for sg_group;

revoke execute on package public.dbms_output from sg_user;
drop package dba.sg_dba_pkg;
drop procedure sg_owner.sg_proc;
drop table sg_owner.sg_tbl;
drop user sg_member;
drop user sg_group;
drop user sg_user;
drop user sg_owner;

--+ holdcas off;
