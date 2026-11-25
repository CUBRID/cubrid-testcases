/**
 *  This test case verifies CBRD-25607: when dba or a member of the owner group grants or
 *  revokes a privilege on an object, grantor_name of db_auth is the owner of the object,
 *  not the user who ran the statement.
 *
 *  This file compares the owner with a member of the dba group and with a member of the
 *  owner group.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  the owner grants SELECT on owner.tbl and EXECUTE on owner.hello to temp_user, grantor OWNER
 *    Case 2:  the owner revokes both, and the rows are gone
 *    Case 3:  dba_member grants both to temp_user, and the grantor is OWNER
 *    Case 4:  dba_member revokes both, and the rows are gone
 *    Case 5:  the owner grants both to temp_user again, grantor OWNER, and revokes them
 *    Case 6:  owner_member grants both to temp_user, and the grantor is OWNER
 *    Case 7:  owner_member revokes both, and the rows are gone
 */
select 'create test users' from dual;
CREATE USER owner;
CREATE USER dba_member groups dba;
CREATE USER owner_member groups owner;
CREATE USER temp_user;

CREATE TABLE owner.tbl (col1 int);

CREATE FUNCTION owner.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';



evaluate 'Case 1: the owner grants SELECT on owner.tbl and EXECUTE on owner.hello to temp_user, grantor OWNER';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'Case 2: the owner revokes both, and the rows are gone';
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 3: dba_member grants both to temp_user, and the grantor is OWNER';
CALL LOGIN('dba_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user WITH GRANT OPTION;;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 4: dba_member revokes both, and the rows are gone';
CALL LOGIN('dba_member','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'Case 5: the owner grants both to temp_user again, grantor OWNER, and revokes them';
CALL LOGIN('owner','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;


evaluate 'Case 6: owner_member grants both to temp_user, and the grantor is OWNER';
CALL LOGIN('owner_member','') ON  CLASS db_user;
GRANT select ON owner.tbl TO temp_user WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE owner.hello TO temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner, grants from db_authorization where owner != 'PUBLIC';


evaluate 'Case 7: owner_member revokes both, and the rows are gone';
CALL LOGIN('owner_member','') ON  CLASS db_user;
revoke select on owner.tbl from temp_user;
revoke EXECUTE on PROCEDURE owner.hello from temp_user;

select grantor_name, grantee_name, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


CALL LOGIN('dba','') ON  CLASS db_user;
DROP USER temp_user;
DROP USER owner_member;
DROP USER dba_member;

DROP TABLE owner.tbl;
DROP FUNCTION owner.hello;

DROP USER owner;
