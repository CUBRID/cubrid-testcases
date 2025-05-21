/* Verfified the CBRD-25627
As-is: if changed the owner of objects then it is not updated on db_auth
To-be: If changed the owner of objects then revoke all grantors
*/


create user u1;
create user u2;
create user u3;

evaluate 'case 2: changed owner for view';

evaluate 'create u1.tbl, u1.v1_tbl';
create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;

evaluate 'connect to u1 & u1.tbl grant to u2 & u1.v1_tbl grant to u3';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;

evaluate 'connect to u2 & u1.tbl grant to u3';
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;


evaluate 'connect to dba';
call login(class db_user,'dba','');
select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to u3';
call login('u3','') on class db_user;
select * from u1.v1_tbl;


evaluate 'connect to dba & changed owner u1.v1_tbl -> u3.v1_tbl';
call login('dba','') on class db_user;
ALTER VIEW u1.v1_tbl OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select class_name, owner_name from db_class where class_name = 'v1_tbl' order by class_name;

show create view u3.v1_tbl;


evaluate 'Test init';
drop table u1.tbl;
drop view u3.v1_tbl;
drop user u1;
drop user u2;
drop user u3;