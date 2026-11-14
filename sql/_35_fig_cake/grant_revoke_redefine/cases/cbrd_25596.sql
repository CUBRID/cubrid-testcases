/**
 *  This test case verifies CBRD-25596: a GRANT without WITH GRANT OPTION, run again for a
 *  privilege that the user holds WITH GRANT OPTION, does not change is_grantable of db_auth
 *  from YES to NO.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a second GRANT SELECT on dba.vtbl to u1 leaves one row with is_grantable NO
 *    Case 2:  GRANT SELECT WITH GRANT OPTION sets is_grantable YES, and a later plain GRANT keeps it YES
 *    Case 3:  with SELECT WITH GRANT OPTION and INSERT, a plain GRANT SELECT, INSERT keeps is_grantable of SELECT YES
 */

drop table if exists dba.vtbl, dba.tbl;

create user u1;

create table dba.tbl (col1 int);
create view dba.vtbl as select * from tbl;

evaluate 'Case 1: a second GRANT SELECT on dba.vtbl to u1 leaves one row with is_grantable NO';
GRANT SELECT ON dba.vtbl TO u1;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

GRANT SELECT ON dba.vtbl TO u1;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner = 'U1' order by owner;


evaluate 'Case 2: GRANT SELECT WITH GRANT OPTION sets is_grantable YES, and a later plain GRANT keeps it YES';
GRANT SELECT ON dba.vtbl TO u1 WITH GRANT OPTION;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner = 'U1' order by owner;

GRANT SELECT ON dba.vtbl TO u1;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner = 'U1' order by owner;

revoke select on dba.vtbl from u1;
drop view dba.vtbl;



evaluate 'Case 3: with SELECT WITH GRANT OPTION and INSERT, a plain GRANT SELECT, INSERT keeps is_grantable of SELECT YES';
create table dba.vtbl (col1 int);

GRANT SELECT ON dba.vtbl TO u1 WITH GRANT OPTION;
GRANT INSERT ON dba.vtbl TO u1;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner = 'U1' order by owner;


GRANT SELECT, INSERT ON dba.vtbl TO u1;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner = 'U1' order by owner;


revoke select, insert on dba.vtbl from u1;
drop table dba.tbl;
drop table dba.vtbl;
drop user u1;
