/* Verified the CBRD-25607
As-is: When grant/revoke from dba or owner group user, the grantor_name is set to the grantor name
To-be: When grant/revoke from dba or owner group user, the grantor_name is set to the owner name
 */


select 'create test users' from dual;
CREATE USER owner;
CREATE USER grantable;
CREATE USER temp_user;


evaluate 'create owner.tbl, owner.hello';
CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';



evaluate 'case 1: compare to "owner" and "dba"';
evaluate 'connect to owner user & owner.tbl, owner.hello grant to temp_user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT SELECT ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'revoke from temp_user';
revoke SELECT on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba user';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT SELECT ON owner.tbl TO temp_user WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'Test init';
revoke SELECT on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC';




evaluate 'case 2: compare to "owner" and "grantable"';
evaluate 'connect to owner & owner.tbl grant to grantable';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable WITH GRANT OPTION;
evaluate 'grantable user grant owner.hello, ERROR: Grant option is not allowed';
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable WITH GRANT OPTION;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba';
CALL LOGIN('grantable','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
evaluate 'ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'Test init';
evaluate 'connect to grantable & revoke from temp_user';
CALL LOGIN('grantable','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;

evaluate 'connect to owner & revoke from grantable';
CALL LOGIN('owner','') ON  CLASS db_user;
revoke select on owner.tbl from grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba & removed test users & test objects';
CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER grantable;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;