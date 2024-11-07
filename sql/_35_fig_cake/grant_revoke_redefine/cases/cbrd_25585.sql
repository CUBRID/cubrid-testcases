/* Verified the CBRD-25585
As-is: A user execute the grant(do not have 'with grant option'),
       that results is 'Execute OK'(Actually 'No operation')
To-be: ERROR: SELECT authorization failure
*/

create user u1;
create user u2;

evaluate 'case 1: When a user without permissions grants privileges to themselves';
create table dba.tbl (col1 int);

CREATE FUNCTION dba.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'grant to dba.tbl, dba.hello from dba to dba';
GRANT SELECT ON dba.tbl TO dba;
GRANT EXECUTE ON PROCEDURE dba.hello TO dba;

evaluate 'connect to u1';
call login('u1','') on class db_user;

evaluate 'ERROR: SELECT authorization failure';
GRANT SELECT ON dba.tbl TO u1;

evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON dba.tbl TO dba;

evaluate 'ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE dba.hello TO u1;
GRANT EXECUTE ON PROCEDURE dba.hello TO dba;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;

evaluate 'connect to dba and test init';
call login(class db_user,'dba','');
drop FUNCTION dba.hello;
drop table dba.tbl;



evaluate 'case 2: When a user without WITH GRANT OPTION privilege grants privileges to themselves';
create table dba.tbl (col1 int);

CREATE FUNCTION dba.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

GRANT SELECT ON dba.tbl TO u1;
GRANT EXECUTE ON PROCEDURE dba.hello TO u1;

evaluate 'connect u1';
call login('u1','') on class db_user;

evaluate 'ERROR: No GRANT option';
GRANT SELECT ON dba.tbl TO u1;
GRANT SELECT ON dba.tbl TO u2;

evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON dba.tbl TO dba;

evaluate 'ERROR: Only the DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE dba.hello TO u1;
GRANT EXECUTE ON PROCEDURE dba.hello TO u2;

evaluate 'ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE dba.hello TO dba;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name IN ('U1', 'U2') order by owner.name;


evaluate 'connect to dba and test init';
call login(class db_user,'dba','');
revoke SELECT ON dba.tbl from u1;
revoke EXECUTE ON PROCEDURE dba.hello from u1;
drop table dba.tbl;
drop FUNCTION dba.hello;



evaluate 'case 3: When a user with WITH GRANT OPTION privilege grants privileges to themselves';
create table dba.tbl (col1 int);

CREATE FUNCTION dba.hello() RETURN STRING
AS LANGUAGE JAVA
NAME 'SpCubrid.HelloCubrid() return java.lang.String';

GRANT SELECT ON dba.tbl TO u1 WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE dba.hello TO u1;

evaluate 'connect to u1, success';
call login('u1','') on class db_user;
GRANT SELECT ON dba.tbl TO u1;
GRANT SELECT ON dba.tbl TO u2;

evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON dba.tbl TO dba;

evaluate 'ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE dba.hello TO u1;
GRANT EXECUTE ON PROCEDURE dba.hello TO u2;

evaluate 'ERROR: Only DBA and the owner can grant the EXECUTE privilege';
GRANT EXECUTE ON PROCEDURE dba.hello TO dba;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name IN ('U1', 'U2') order by owner.name;


evaluate 'connect to u1 and revoke to dba.tbl from u2';
call login(class db_user,'u1','');
revoke SELECT ON dba.tbl from u2;

evaluate 'connecdt to dba and test done';
call login(class db_user,'dba','');
revoke SELECT ON dba.tbl from u1;
revoke EXECUTE ON PROCEDURE dba.hello from u1;
drop table dba.tbl;
drop FUNCTION dba.hello;
drop user u1;
drop user u2;