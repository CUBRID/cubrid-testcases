/* Verified the CBRD-25486
As-is: if removed the object then remove the related data on the db_authorization table
To-be: if removed the object then set 'NULL' relate data on the db_authorization table

Scenario 03: Drop javasp when javasp permission granted to other users
*/

create user u1;
create user u2;
create user u3;

evaluate 'create javasp u1.hello';
CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'connect to u1 & u2, u3 grant to u1.hello';
call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to dba, drop u1.hello';
call login('dba','') on class db_user;
DROP FUNCTION u1.hello;

evaluate 'check to the u1.hello removed';
select * from db_auth where grantee_name != 'PUBLIC'  order by grantor_name;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC'  order by owner.name;
select * from db_stored_procedure;


evaluate 'Test done';
drop user u1;
drop user u2;
drop user u3;