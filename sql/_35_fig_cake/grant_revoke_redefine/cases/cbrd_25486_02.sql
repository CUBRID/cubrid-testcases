/* Verified the CBRD-25486
As-is: if removed the object then remove the related data on the db_authorization table
To-be: if removed the object then set 'NULL' relate data on the db_authorization table

Scenario 02: Drop view table when view table permission granted to other users
*/

create user u1;
create user u2;
create user u3;

evaluate 'create table u1.tbl, create view u1.v1_tbl';
create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;

evaluate 'connect to u1, u2 grant to u1.tbl, u3 grant to u1.v1_tbl';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;

evaluate 'connect to u2, u3 grant to u1.tbl';
call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

evaluate 'connect to dba, check permission';
call login(class db_user,'dba','');
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to u3, select u1.v1_tbl';
call login('u3','') on class db_user;
select col1 from u1.v1_tbl;

evaluate 'connect to dba, drop u1.v1_tbl';
call login('dba','') on class db_user;
DROP VIEW u1.v1_tbl;

evaluate 'check to the v1_tbl removed';
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;
select * from db_class where class_name ='v1_tbl' order by class_name;
evaluate 'ERROR: Unknown class "u1.v1_tbl';
show create view u1.v1_tbl;

evaluate 'Test done';
drop table u1.tbl;
drop user u1;
drop user u2;
drop user u3;