/**
 *  This test case verifies CBRD-25627: when the owner of an object changes, the grants that
 *  the old owner gave are revoked. Before the fix db_auth kept them.
 *  This file checks a Java stored function. Revised for CBRD-26470, which changed the message
 *  of the refused owner change.
 *
 *  Coverage:
 *    Case 1: u1 grants EXECUTE on u1.hello to u2 and u3, and db_auth shows the grants
 *    Case 2: u3 changing the owner of u1.hello is refused (the owner or a member of DBA group can
 *            alter stored procedure)
 *    Case 3: dba changes the owner of u1.hello to u3, the grants of u1 are gone from db_auth
 *            and the function is owned by u3
 */


create user u1;
create user u2;
create user u3;

evaluate 'Case 1: u1.hello is created, and u1 grants EXECUTE on it to u2 and u3';
CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 2: u3 changing the owner of u1.hello is refused: the owner or a member of DBA group can alter stored procedure';
call login('u3','') on class db_user;
ALTER FUNCTION u1.hello OWNER TO u3;

evaluate 'Case 3: dba changes the owner of u1.hello to u3, the grants of u1 are revoked';
call login('dba','') on class db_user;
ALTER FUNCTION u1.hello OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select sp_name, owner from db_stored_procedure;


drop FUNCTION u3.hello;
drop user u1;
drop user u2;
drop user u3;