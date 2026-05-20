/*
Verify to the CBRD-25909
CBRD-25909: Spec change when change to the owner on the class/vclass or stored procedure
*/

create user u1;
create user u2;
create user u3;

-- test for 6-2 ~ 6-4
create user u4;
create user u5;

evaluate '1. change to the table owner';
create table u1.tbl (col1 int);

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC'  order by 1;


call login('dba','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name = 'tbl';

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
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
ALTER VIEW u1.v1_tbl OWNER TO u2;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
ALTER VIEW u2.v1_tbl OWNER TO u3;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name ='v1_tbl';
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

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

call login('u3','') on class db_user;
evaluate 'check error message';
ALTER FUNCTION u1.hello OWNER TO u3;
ALTER FUNCTION u1.hello OWNER TO u3 COMMENT 'aaaa';
ALTER FUNCTION u1.hello COMMENT 'aaaa';
DROP FUNCTION u1.hello;


call login('u1','') on class db_user;
evaluate 'success';
ALTER FUNCTION u1.hello COMMENT 'aaaa';
select sp_name, owner, comment from db_stored_procedure order by 1;


call login('dba','') on class db_user;
ALTER FUNCTION u1.hello OWNER TO u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select sp_name, owner from db_stored_procedure order by 1;

call login(class db_user,'dba','');
drop FUNCTION u3.hello;



evaluate '4. Change the owner of a table to which you have granted ALTER permission';
create table u1.tbl (col1 int);
create table u1.tbl2 (col1 int);


call login('u1','') on class db_user;
GRANT ALTER ON u1.tbl TO u2;
GRANT ALTER ON u1.tbl2 TO u2 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT ALTER ON u1.tbl2 TO u3 WITH GRANT OPTION;


call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('u3','') on class db_user;
evaluate 'check error meessage';
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;


call login('u2','') on class db_user;
evaluate 'check error meessage';
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;


call login('dba','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name in ('tbl', 'tbl2') order by 1;

call login(class db_user,'dba','');
drop table u3.tbl;
drop table u3.tbl2;



evaluate '5. change to the owner for partition table';
call login ('u1') on class db_user;
create table t1_r (c1 int) comment 'u1 > t1_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u1 > t1_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u1 > t1_r > p1 (range)'
    );

create table t1_h (c1 int) comment 'u1 > t1_h (hash)'
  partition by hash (c1) partitions 2;

create table t1_l (c1 int) comment 'u1 > t1_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u1 > t1_l > p0 (list)',
      partition p1 values in (1) comment 'u1 > t1_l > p1 (list)'
    );

grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;
grant select on t1_l to u2 with grant option;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login ('u2') on class db_user;

grant select on u1.t1_r to u3 with grant option;
grant select on u1.t1_h to u3 with grant option;
grant select on u1.t1_l to u3 with grant option;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login ('u3') on class db_user;
evaluate 'check error message';
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;


call login ('u2') on class db_user;
evaluate 'check error message';
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;


call login ('dba') on class db_user;
evaluate 'success';
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name in ('t1_r', 't1_h', 't1_l') order by 1;

drop table u3.t1_r;
drop table u3.t1_h;
drop table u3.t1_l;



evaluate '6-1. change to owner(u1->u3) when after grant to permission u1.tbl1';
CREATE TABLE u1.tbl1 (col1 int);

GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U2 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION;


call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u2;
GRANT INSERT ON u1.tbl1 TO u2 WITH GRANT OPTION;


call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u1.tbl1 OWNER TO u3;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

drop table u3.tbl1;



evaluate '6-2. change to owner(u1->u3) when after grant to permission u1.tbl1';
CREATE TABLE u1.tbl1 (col1 int);

GRANT SELECT ON u1.tbl1 TO u2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION;
GRANT SELECT ON u1.tbl1 TO u4;


call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;


call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u4 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3;


call login('dba','') on class db_user;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u1.tbl1 OWNER TO u3;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

drop table u3.tbl1;



evaluate '6-3. Check to mask(bit) on db_authorization';
CREATE TABLE u1.tbl1 (col1 int);

GRANT INSERT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT INSERT ON u1.tbl1 TO u4;


call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u4 WITH GRANT OPTION;


call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u2;


call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

CALL change_owner ('u1.tbl1', 'u3') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('u2','') on class db_user;
GRANT INSERT ON u3.tbl1 TO U1;
evaluate 'ERROR: SELECT authorization failure';
GRANT SELECT ON u3.tbl1 TO u1;

insert into u3.tbl1 values(1);
select * from u3.tbl1 order by 1;


call login('u4','') on class db_user;
evaluate 'ERROR: INSERT authorization failure';
GRANT INSERT ON u3.tbl1 TO U1;
evaluate 'success';
GRANT SELECT ON u3.tbl1 TO u1;

insert into u3.tbl1 values(2);
select * from u3.tbl1 order by 1;


call login('dba','') on class db_user;
drop table u3.tbl1;



evaluate '6-4. Check to mask(bit) on db_authorization';
create table u1.tbl (col1 int);

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u2','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
evaluate 'success';
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u3','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
evaluate 'success';
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u4','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
evaluate 'success';
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u5','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
evaluate 'success';
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;


call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u1.TBL OWNER TO u2;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u2.TBL OWNER TO u3;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u3.TBL OWNER TO u4;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

ALTER TABLE u4.TBL OWNER TO u5;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;

drop table u5.tbl;


evaluate 'Test done';
drop user u5;
drop user u4;
drop user u3;
drop user u2;
drop user u1;
