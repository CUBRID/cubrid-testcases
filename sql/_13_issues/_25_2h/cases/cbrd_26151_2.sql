/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 2: With WITH GRANT OPTION, each user sees only the authorizations
 * where they appear as grantor or grantee. u1 (object owner) additionally
 * sees all grants on objects it owns. DBA sees all.
 */

--+ server-message on

create user u1;
create user u2;
create user u3;

call login('u1','') on class db_user;
create table tbl1 (col1 int);
GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION;

create function u1.test_java_sp() return string
as language java
name 'SpCubrid.HelloCubrid() return java.lang.String';
GRANT EXECUTE ON PROCEDURE u1.test_java_sp TO u2;

CREATE OR REPLACE PROCEDURE u1.test_pl() AS
BEGIN
        DBMS_OUTPUT.put_line('test');
END;
GRANT EXECUTE ON PROCEDURE u1.test_pl TO u3;

call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;

evaluate('2-1. login as u1: all authorizations on u1-owned objects (owner)');
call login('u1','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

evaluate('2-2. login as u2: authorizations where u2 is grantor or grantee');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

evaluate('2-3. login as u3: only authorizations where u3 is grantee');
call login('u3','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

evaluate('2-4. login as dba: all authorizations are visible');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' and grantee_name != 'INFORMATION_SCHEMA' order by grantor_name, grantee_name, auth_type;

drop table u1.tbl1;
drop function u1.test_java_sp;
drop PROCEDURE u1.test_pl;
drop user u1;
drop user u2;
drop user u3;

--+ server-message off
