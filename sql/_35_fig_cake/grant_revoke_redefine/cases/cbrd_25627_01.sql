/* Verfified the CBRD-25627
As-is: if changed the owner of objects then it is not updated on db_auth
To-be: If changed the owner of objects then revoke all grantors
*/


create user u1;
create user u2;
create user u3;

evaluate 'case 1: changed owner for table';

evaluate 'create u1.tbl table';
create table u1.tbl (col1 int);

evaluate 'connect to u1 & u1.tbl grant to u2';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;

evaluate 'connect to u1 & u1.tbl grant to u3';
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;


select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'connect to dba & changed owner u1.tbl -> u3.tbl';
call login('dba','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select class_name, owner_name from db_class where class_name = 'tbl' order by class_name;

evaluate 'Test init';
drop table u3.tbl;
drop user u1;
drop user u2;
drop user u3;