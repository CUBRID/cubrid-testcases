/* Verified the CBRD-25607
As-is: When grant/revoke from dba or owner group user, the grantor_name is set to the grantor name
To-be: When grant/revoke from dba or owner group user, the grantor_name is set to the owner name
 */


select 'create test users' from dual;
CREATE USER owner;
CREATE USER grantable;
CREATE USER grantable_member groups grantable;
CREATE USER temp_user;


evaluate 'create owner.tbl, owner.hello';
CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';


evaluate 'case 5: grantable user grants to privileges other user (negative)';
evaluate 'connect to owner & owner.tbl grant to grantable user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable WITH GRANT OPTION;
evaluate 'owner.hello grant to grantable user, ERROR: Grant option is not allowed';
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable WITH GRANT OPTION;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;

evaluate 'connect to grantable_member & owner.tbl grant to grantable user, ERROR: SELECT authorization failure';
CALL LOGIN('grantable_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;

evaluate 'owner.hello grant to grantable user, ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

evaluate 'connect to grantable & owner.tbl grant to grantable_member user, temp_user';
CALL LOGIN('grantable','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable_member WITH GRANT OPTION;
GRANT select ON owner.tbl TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;


evaluate 'connect to grantable_member';
CALL LOGIN('grantable_member','') ON CLASS db_user;
evaluate 'owner.tbl grant to grantable_member user, ERROR: Cannot revoke privileges from self';
revoke select on owner.tbl from grantable_member;
evaluate 'owner.tbl grant to temp_user user, ERROR: ERROR: No GRANT option';
revoke select on owner.tbl from temp_user;


evaluate 'Test init';
evaluate 'connect to grantable_member & revoke from grantable_member, temp_user';
CALL LOGIN('grantable','') ON  CLASS db_user;
revoke select on owner.tbl from grantable_member;
revoke select on owner.tbl from temp_user;

evaluate 'connect to owner & revoke from grantable';
CALL LOGIN('owner','') ON  CLASS db_user;
revoke select on owner.tbl from grantable;




evaluate 'case 5-1: grantable user grants to privileges other user (positive)';
evaluate 'connect to owner & owner.tbl grant to grantable_member, owner.hello';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable_member WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable_member;

evaluate 'connect to grantable_member & owner.tbl grant to temp_user';
CALL LOGIN('grantable_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'Test init';
evaluate 'connect to grantable_member & revoke from temp_user';
CALL LOGIN('grantable_member','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;

evaluate 'connect to owner & revoke from grantable_member';
CALL LOGIN('owner','') ON  CLASS db_user;
revoke select on owner.tbl from grantable_member;
revoke EXECUTE on PROCEDURE owner.hello from grantable_member;



evaluate 'connect to dba & removed test users & test objects';
CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER grantable_member;
DROP USER grantable;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;
