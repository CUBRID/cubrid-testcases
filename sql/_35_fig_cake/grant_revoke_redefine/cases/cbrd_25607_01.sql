/**
 *  This test case verifies CBRD-25607: when dba or a member of the owner group grants or
 *  revokes a privilege on an object, grantor_name of db_auth is the owner of the object,
 *  not the user who ran the statement.
 *
 *  This file compares the owner with dba and with a user who holds a grant option.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  the owner grants SELECT on owner.tbl and EXECUTE on owner.hello to temp_user, grantor OWNER
 *    Case 2:  the owner revokes both, and the rows are gone
 *    Case 3:  dba grants both to temp_user, and the grantor is OWNER, not DBA
 *    Case 4:  dba revokes both, and the rows are gone
 *    Case 5:  the owner grants SELECT WITH GRANT OPTION to grantable, and EXECUTE WITH GRANT OPTION fails with an error
 *    Case 6:  grantable grants SELECT to temp_user as grantor GRANTABLE, and its GRANT EXECUTE fails with an error
 *    Case 7:  grantable revokes from temp_user, the owner revokes from grantable, and the rows are gone
 */


select 'create test users' from dual;
CREATE USER owner;
CREATE USER grantable;
CREATE USER temp_user;


CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';



evaluate 'Case 1: the owner grants SELECT on owner.tbl and EXECUTE on owner.hello to temp_user, grantor OWNER';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT SELECT ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 2: the owner revokes both, and the rows are gone';
revoke SELECT on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 3: dba grants both to temp_user, and the grantor is OWNER, not DBA';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT SELECT ON owner.tbl TO temp_user WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 4: dba revokes both, and the rows are gone';
revoke SELECT on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC';




evaluate 'Case 5: the owner grants SELECT WITH GRANT OPTION to grantable, and EXECUTE WITH GRANT OPTION fails with an error';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable WITH GRANT OPTION;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 6: grantable grants SELECT to temp_user as grantor GRANTABLE, and its GRANT EXECUTE fails with an error';
CALL LOGIN('grantable','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
-- only dba and the owner can grant EXECUTE on a stored procedure
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 7: grantable revokes from temp_user, the owner revokes from grantable, and the rows are gone';
CALL LOGIN('grantable','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;

CALL LOGIN('owner','') ON  CLASS db_user;
revoke select on owner.tbl from grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER grantable;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;
