/**
 *  This test case verifies CBRD-25607: when dba or a member of the owner group grants or
 *  revokes a privilege on an object, grantor_name of db_auth is the owner of the object,
 *  not the user who ran the statement.
 *
 *  This file runs grants among dba, the dba group, the owner, the owner group and a user
 *  with a grant option, including grants of a user to itself.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  dba grants SELECT on owner.tbl and EXECUTE on owner.hello to dba_member, grantor OWNER
 *    Case 2:  dba_member grants both to dba, grantor OWNER
 *    Case 3:  dba_member revokes from dba, dba revokes from dba_member, and the rows are gone
 *    Case 4:  dba grants both to dba, and no row is added
 *    Case 5:  the owner grants both to the owner, and no row is added
 *    Case 6:  grantable grants SELECT to itself with no effect, and its GRANT EXECUTE fails with an error
 *    Case 7:  dba revokes from grantable, and the rows are gone
 *    Case 8:  dba_member grants both to dba_member, and no row is added
 *    Case 9:  owner_member grants both to owner_member, and no row is added
 */


select 'create test users' from dual;
CREATE USER owner;
CREATE USER grantable;
CREATE USER dba_member groups dba;
CREATE USER owner_member groups owner;
CREATE USER grantable_member groups grantable;
CREATE USER temp_user;


CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';




evaluate 'Case 1: dba grants SELECT on owner.tbl and EXECUTE on owner.hello to dba_member, grantor OWNER';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;

evaluate 'Case 2: dba_member grants both to dba, grantor OWNER';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;


evaluate 'Case 3: dba_member revokes from dba, dba revokes from dba_member, and the rows are gone';
CALL LOGIN('dba_member','') ON  CLASS db_user;
revoke select on owner.tbl from dba;
revoke EXECUTE on PROCEDURE owner.hello from dba;

CALL LOGIN('dba','') ON  CLASS db_user;
revoke select on owner.tbl from dba_member;
revoke EXECUTE on PROCEDURE owner.hello from dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'Case 4: dba grants both to dba, and no row is added';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'Case 5: the owner grants both to the owner, and no row is added';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO owner;
GRANT EXECUTE ON PROCEDURE owner.hello TO owner;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'Case 6: grantable grants SELECT to itself with no effect, and its GRANT EXECUTE fails with an error';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable;

CALL LOGIN('grantable','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable;
-- only dba and the owner can grant EXECUTE on a stored procedure
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;


evaluate 'Case 7: dba revokes from grantable, and the rows are gone';
CALL LOGIN('dba','') ON  CLASS db_user;
revoke select on owner.tbl from grantable;
revoke EXECUTE ON PROCEDURE owner.hello from grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;




evaluate 'Case 8: dba_member grants both to dba_member, and no row is added';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;




evaluate 'Case 9: owner_member grants both to owner_member, and no row is added';
CALL LOGIN('owner_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO owner_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO owner_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER grantable_member;
DROP USER owner_member;
DROP USER dba_member;
DROP USER grantable;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;
