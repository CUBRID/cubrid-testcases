/* Verified the CBRD-25486
As-is: if removed the object then remove the related data on the db_authorization table
To-be: if removed the object then set 'NULL' relate data on the db_authorization table

Scenario 01: Drop table when table permission granted to other users
*/

create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);

evaluate 'connect to u1,  u2 grant to u1.tbl';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;

evaluate 'connect to u2, u3 grant to u1.tbl';
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;


select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;

evaluate 'connect to u2';
call login('u2','') on class db_user;

evaluate 'drop the u1.tbl, ERROR: ALTER authorization failure';
DROP TABLE u1.tbl;

evaluate 'connect to dba, drop the u1.tbl';
call login('dba','') on class db_user;
DROP TABLE u1.tbl;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;

select * from db_class where class_name = 'tbl' order by class_name;

evaluate 'Test done';
drop user u1;
drop user u2;
drop user u3;