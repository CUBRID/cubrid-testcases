/* Verified the CBRD-25607
As-is: When grant/revoke from dba or owner group user, the grantor_name is set to the grantor name
To-be: When grant/revoke from dba or owner group user, the grantor_name is set to the owner name
 */
select 'create test users' from dual;
CREATE USER owner;
CREATE USER dba_member groups dba;
CREATE USER owner_member groups owner;
CREATE USER temp_user;

evaluate 'create owner.tbl, owner.hello';
CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';



evaluate 'case 3: compare to "owner" and "dba_member"';
evaluate 'connect to owner & owner.tbl, owner.hello grant to temp_user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'revoke from temp_user';
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba_member & owner.tbl, owner.hello grant to temp_user';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user WITH GRANT OPTION;;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'Test init';
evaluate 'connect to dba_member & revoke from temp_user';
CALL LOGIN('dba_member','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'case 4: compare to "owner" and "owner group"';
evaluate 'connect to owner & owner.tbl, owner.hello grant to temp_user';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'revoke from temp_user';
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;


evaluate 'connect to owner_member & owner.tbl, owner.hello grant to temp_user';
CALL LOGIN('owner_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC';


evaluate 'Test init';
evaluate 'connect to owner_member & revoke from temp_user';
CALL LOGIN('owner_member','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba & removed test users & test objects';
CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER owner_member;
DROP USER dba_member;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;
