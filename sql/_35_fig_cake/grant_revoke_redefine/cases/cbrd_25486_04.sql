/* Verified the CBRD-25486
As-is: if removed the object then remove the related data on the db_authorization table
To-be: if removed the object then set 'NULL' relate data on the db_authorization table

Scenario 04: Drop table from granted alter permission users
*/

create user u1;
create user u2;
create user u3;

evaluate 'create table u1.tbl, u1.tbl2';
create table u1.tbl (col1 int);
create table u1.tbl2 (col1 int);

evaluate 'connect u1 & u2 grant to u1.tbl, u1.tbl2';
call login('u1','') on class db_user;
GRANT ALTER ON u1.tbl TO u2;
GRANT ALTER ON u1.tbl2 TO u2 WITH GRANT OPTION;

evaluate 'connect u2 & u3 grant to u1.tbl2';
call login('u2','') on class db_user;
GRANT ALTER ON u1.tbl2 TO u3 WITH GRANT OPTION;

evaluate 'connect to dba';
call login('dba','') on class db_user;
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to u3 & drop u1.tbl, ERROR: ERROR: ALTER authorization failure;';
call login('u3','') on class db_user;
DROP TABLE u1.tbl;

evaluate 'connect to u2 & drop u1.tbl, success';
call login('u2','') on class db_user;
DROP TABLE u1.tbl;

evaluate 'connect to dba';
call login('dba','') on class db_user;


evaluate 'check to the u1.tbl removed';
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;
select * from db_class where class_name = 'tbl';


evaluate 'connect to u3 & drop u1.tbl2, success';
call login('u3','') on class db_user;
DROP TABLE u1.tbl2;


evaluate 'connect to dba';
call login('dba','') on class db_user;

evaluate 'check to the u1.tbl2 removed';
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;
select * from db_class where class_name = 'tbl2';


evaluate 'Test done';
drop user u1;
drop user u2;
drop user u3;