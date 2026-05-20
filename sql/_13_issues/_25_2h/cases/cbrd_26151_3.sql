/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 3: A DBA group member can view all authorizations
 * (AC #1: DBA / DBA-group members see all).
 */

--+ server-message on

create user u1;
create user u2;
create user u3;
create user dba_member;

alter user dba add members dba_member;

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

evaluate('3-1. login as dba_member: all authorizations visible (DBA group member)');
call login('dba_member','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('3-2. login as dba: all authorizations visible (reference)');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

drop table u1.tbl1;
drop function u1.test_java_sp;
drop PROCEDURE u1.test_pl;
drop user u1;
drop user u2;
drop user u3;
drop user dba_member;

--+ server-message off
