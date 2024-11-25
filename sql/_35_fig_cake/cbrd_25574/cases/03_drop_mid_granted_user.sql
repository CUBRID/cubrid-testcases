/* Verified the CBRD-25574
As-is: if dropped user then set 'NULL' related data on the db_auth, db_authorization table
To-be: if dropped user then remove the related data on the db_auth, db_authorization table
*/

create user u1;
create user u2;
create user u3;
create user u4;

evaluate 'create table u1.tbl, create javasp u1.hello, create u1.v1_tbl';
create table u1.tbl (col1 int);

CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

create view u1.v1_tbl as select * from u1.tbl;


evaluate 'connect to u1';
call login('u1','') on class db_user;

evaluate 'u2 grant to u1.tbl (granted select twice, but duplicate granted does not work)';
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

GRANT SELECT ON u1.tbl TO u2;
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;


evaluate 'u2 grant to u1.tbl (insert)';
GRANT INSERT ON u1.tbl TO u2 WITH GRANT OPTION;

evaluate 'u2 grant to u1.hello, u3 grant to u1.v1_tbl';
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT SELECT ON u1.v1_tbl TO u3;

evaluate 'connect u2 & u3 grant to u1.tbl (select, insert)';
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl TO u3;

evaluate 'connect to u3 & u4 grant to u1.tbl';
call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl TO u4 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to dba & drop user u2';
call login('dba','') on class db_user;
DROP USER u2;

select * from db_auth where grantee_name != 'PUBLIC';

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;

select name from db_user order by name;


evaluate 'Test done';
drop function u1.hello;
drop table u1.tbl;
drop view u1.v1_tbl;
drop user u1;
drop user u3;
drop user u4;