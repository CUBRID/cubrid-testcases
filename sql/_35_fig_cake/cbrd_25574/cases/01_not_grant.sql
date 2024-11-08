/* Verified the CBRD-25574
As-is: if dropped user then set 'NULL' related data on the db_auth, db_authorization table
To-be: if dropped user then remove the related data on the db_auth, db_authorization table
*/


create user u1;
create user u2;

evaluate 'create table u1.tbl';
create table u1.tbl (col1 int);

select name from db_user order by name;

evaluate 'drop user u1, ERROR: Cannot drop the user who owns database objects';
drop user u1;


evaluate 'drop user u2, success';
drop user u2;

select name from db_user order by name;


evaluate 'Test done';
drop table u1.tbl;
drop user u1;