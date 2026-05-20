/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 1: Without WITH GRANT OPTION, each user sees only the
 * authorizations where they appear as grantor or grantee. DBA sees all.
 */

--+ server-message on

create user u1;
create user u2;
create user u3;

call login('u1','') on class db_user;
create table tbl1 (col1 int);
GRANT SELECT ON u1.tbl1 TO U2;
GRANT INSERT ON u1.tbl1 TO U3;

create function u1.test_java_sp() return string
as language java
name 'SpCubrid.HelloCubrid() return java.lang.String';
GRANT EXECUTE ON PROCEDURE u1.test_java_sp TO u2;

CREATE OR REPLACE PROCEDURE u1.test_pl() AS
BEGIN
        DBMS_OUTPUT.put_line('test');
END;
GRANT EXECUTE ON PROCEDURE u1.test_pl TO u3;

evaluate('1-1. login as u1: only authorizations where u1 is grantor');
call login('u1','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('1-2. login as u2: only authorizations where u2 is grantee');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('1-3. login as u3: only authorizations where u3 is grantee');
call login('u3','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('1-4. login as dba: all authorizations are visible');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

drop table u1.tbl1;
drop function u1.test_java_sp;
drop PROCEDURE u1.test_pl;
drop user u1;
drop user u2;
drop user u3;

--+ server-message off
