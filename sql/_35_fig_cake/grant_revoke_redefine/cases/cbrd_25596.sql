/* Verified the CBRD-25596
As-is: when the user has the 'with grant option'
       then in the db_auth table, is_gratable can set 'no' by re-executing the grant statement
To-be: in the db_auth table, is_grantable can not set 'no'
*/

create user u1;

evaluate 'case 1: Check if the is_grantable value in the db_auth catalog changes';
create table dba.tbl (col1 int);
create view dba.vtbl on select * from tbl;

evaluate 'u1 grant to dba.vtbl';
GRANT SELECT ON dba.vtbl TO u1;
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

evaluate 'u1 re-grant to dba.vtbl';
GRANT SELECT ON dba.vtbl TO u1;
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;


evaluate 'u1 grant to dba.vtbl (with grant option)';
GRANT SELECT ON dba.vtbl TO u1 WITH GRANT OPTION;
select * from db_auth where grantee_name != 'PUBLIC';

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;

evaluate 'u1 re-grant to dba.vtbl';
GRANT SELECT ON dba.vtbl TO u1;
select * from db_auth where grantee_name != 'PUBLIC';

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;

evaluate 'test done and init';
revoke select on dba.vtbl from u1;
drop table dba.vtbl;



evaluate 'case 2: If two or more permissions are granted, Check whether the is_grantable value in the db_auth catalog has changed';
create table dba.vtbl (col1 int);

evaluate 'u1 grant to dba.vtbl (with grant option)';
GRANT SELECT ON dba.vtbl TO u1 WITH GRANT OPTION;
GRANT INSERT ON dba.vtbl TO u1;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, auth_type;

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;


evaluate 'u1 re-grant to dba.vtbl';
GRANT SELECT, INSERT ON dba.vtbl TO u1;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner.name, grants from db_authorization where owner.name = 'U1' order by owner.name;


evaluate 'test done and init';
revoke select, insert on dba.vtbl from u1;
drop table dba.tbl;
drop table dba.vtbl;
drop user u1;