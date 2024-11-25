/* Verified the CBRD-25574
As-is: if dropped user then set 'NULL' related data on the db_auth, db_authorization table
To-be: if dropped user then remove the related data on the db_auth, db_authorization table
*/

create user u1;
create user u2;
create user u3;

evaluate 'create table u1.tbl, create javasp u1.hello';
create table u1.tbl (col1 int);

CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'connect to u1 & u2 grant to u1.tbl, u1.hello & u3 grant to u1.hello';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

evaluate 'connect to u2 & u3 grant to u1.tbl';
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to dba & drop user u3';
call login('dba','') on class db_user;
drop user u3;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC';


evaluate 'Test done';
drop user u2;
drop table u1.tbl;
drop function u1.hello;
drop user u1;