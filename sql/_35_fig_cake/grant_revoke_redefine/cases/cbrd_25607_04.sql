/* Verified the CBRD-25607
As-is: When grant/revoke from dba or owner group user, the grantor_name is set to the grantor name
To-be: When grant/revoke from dba or owner group user, the grantor_name is set to the owner name
 */


select 'create test users' from dual;
CREATE USER owner;
CREATE USER grantable;
CREATE USER dba_member groups dba;
CREATE USER owner_member groups owner;
CREATE USER grantable_member groups grantable;
CREATE USER temp_user;


evaluate 'create owner.tbl, owner.hello';
CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';




evaluate 'case 6: dba grants privileges to dba groups';
evaluate 'connect to dba & owner.tbl, owner.hello grant to dba_member';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;

evaluate 'connect to dba_member & owner.tbl, owner.hello grant to dba';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;


evaluate 'Test init';
evaluate 'connect to dba_member, revoke from dba';
CALL LOGIN('dba_member','') ON  CLASS db_user;
revoke select on owner.tbl from dba;
revoke EXECUTE on PROCEDURE owner.hello from dba;

evaluate 'connect to dba, revoke from dba_member';
CALL LOGIN('dba','') ON  CLASS db_user;
revoke select on owner.tbl from dba_member;
revoke EXECUTE on PROCEDURE owner.hello from dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'case 7: dba grants privileges to dba';
evaluate 'connect to dba & owner.tbl, owner.hello grant to dba user';
CALL LOGIN('dba','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'case 8: owner grants privileges to owner';
evaluate 'connect to owner & owner.tbl, owner.hello grant to owner user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO owner;
GRANT EXECUTE ON PROCEDURE owner.hello TO owner;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'case 9: grantable user grants privileges to grantable user';
evaluate 'connect to owner & owner.tbl, owner.hello grant to grantable user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable;

evaluate 'connect to grantable & owner.tbl grant to grantable user';
CALL LOGIN('grantable','') ON  CLASS db_user;
GRANT select ON owner.tbl TO grantable;
evaluate 'owner.hello grant to grantable user, ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE owner.hello TO grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;


evaluate 'Test init';
evaluate 'connect to dba & revoke from grantable';
CALL LOGIN('dba','') ON  CLASS db_user;
revoke select on owner.tbl from grantable;
revoke EXECUTE ON PROCEDURE owner.hello from grantable;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;




evaluate 'case 10: dba_member grants privileges to dba_member';
evaluate 'connect to dba_member & owner.tbl, owner.hello grant to dba_member user';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO dba_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO dba_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;




evaluate 'case 11: owner_member grants privileges to owner_member';
evaluate 'connect to owner_member & owner.tbl, owner.hello grant to owner_member user';
CALL LOGIN('owner_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO owner_member;
GRANT EXECUTE ON PROCEDURE owner.hello TO owner_member;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantee_name, object_name, auth_type;



evaluate 'Test init';
evaluate 'connect to dba & removed test users & test objects';
CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER grantable_member;
DROP USER owner_member;
DROP USER dba_member;
DROP USER grantable;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;