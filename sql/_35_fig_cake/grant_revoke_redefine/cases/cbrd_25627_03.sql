/* Verfified the CBRD-25627
As-is: if changed the owner of objects then it is not updated on db_auth
To-be: If changed the owner of objects then revoke all grantors
*/


create user u1;
create user u2;
create user u3;

evaluate 'case 3: changed owner for javasp';

evaluate 'create u1.hello function';
CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'connect to u1 & u1.hello grant to u2, u3';
call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to u3 & changed to owner u1.hello -> u3.hello, ERROR: can only be performed by the DBA or a DBA group member';
call login('u3','') on class db_user;
ALTER FUNCTION u1.hello OWNER TO u3;

evaluate 'connect to dba & changed to owner u1.hello -> u3.hello';
call login('dba','') on class db_user;
ALTER FUNCTION u1.hello OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select sp_name, owner from db_stored_procedure;


evaluate 'Test init';
drop FUNCTION u3.hello;
drop user u1;
drop user u2;
drop user u3;