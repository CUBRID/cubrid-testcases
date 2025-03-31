/*
Verify to the CBRD-25805
CBRD-25805: Now the 'change_owner()' same as the work the 'alter ... owner to'
*/

create user u1;
create user u2;
create user u3;

evaluate '1. change to the table owner';
create table u1.tbl (col1 int);

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC';
select owner.name, grants from db_authorization where owner.name != 'PUBLIC'  order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u1.tbl', 'u3') ON CLASS db_authorizations;

select * from db_auth where grantee_name != 'PUBLIC';
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;
select * from db_class where class_name = 'tbl';

drop table u3.tbl;



evaluate '2. change to the view owner';
create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;


call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;


call login(class db_user,'dba','');
select * from db_auth where grantee_name != 'PUBLIC' order by 1;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u1.v1_tbl', 'u2') ON CLASS db_authorizations;

select * from db_auth where grantee_name != 'PUBLIC' order by 1;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u2.v1_tbl', 'u3') ON CLASS db_authorizations;

select * from db_auth where grantee_name != 'PUBLIC' order by 1;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;
select * from db_class where class_name ='v1_tbl';
show create view u3.v1_tbl;

call login(class db_user,'dba','');
drop table u1.tbl;
drop view u3.v1_tbl;



evaluate '3. change to stored procedure owner';
create function u1.hello() return string
as language java
name 'SpCubrid.HelloCubrid() return java.lang.String';

call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select * from db_auth where grantee_name != 'PUBLIC' order by 1;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;

call login('u3','') on class db_user;
evaluate 'check error message';
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;

call login('u1','') on class db_user;
evaluate 'success';
ALTER FUNCTION u1.hello COMMENT 'aaaa';
select sp_name, owner, comment from db_stored_procedure;

call login('dba','') on class db_user;
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;

select * from db_auth where grantee_name != 'PUBLIC' order by 1;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by 1;
select sp_name, owner from db_stored_procedure;

call login(class db_user,'dba','');
drop FUNCTION u3.hello;

drop user u1;
drop user u2;
drop user u3;