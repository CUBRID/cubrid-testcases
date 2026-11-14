/**
 *  This test case verifies CBRD-25805: change_owner() now does the same work as ALTER ... OWNER TO
 *
 *  Each case grants privileges on an object of u1 among u2 to u5, changes the owner of
 *  the object with change_owner(), and checks db_auth and db_authorization before and after.
 *  Only dba may change the owner, so the same change by other users fails.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  changing the owner of u1.tbl to u3 with change_owner() updates db_auth, db_authorization and db_class
 *    Case 2:  changing the owner of the view u1.v1_tbl to u2 and then to u3 with change_owner() updates db_auth, db_authorization and show create view
 *    Case 3:  u2 with EXECUTE cannot change the owner of the function u1.hello with change_sp_owner(), and dba can
 *    Case 4:  users with ALTER on a table, with or without grant option, cannot change its owner with change_owner(), and dba can
 *    Case 5:  only dba changes the owner of range, hash and list partitioned tables with change_owner()
 *    Case 6:  changing the owner of a table whose SELECT and INSERT grants chain between u2 and u3 updates db_auth and db_authorization
 *    Case 7:  changing the owner of a table whose grants reach u4 through u2 and u3 updates db_auth and db_authorization
 *    Case 8:  after the owner change, the grant options in db_authorization decide what u2 and u4 can grant, insert and select
 *    Case 9:  SELECT grants among u2 to u5 follow a chain of owner changes from u1 to u5, and a GRANT to the owner fails
 */

create user u1;
create user u2;
create user u3;

-- u4 and u5 are used from Case 7 on
create user u4;
create user u5;

evaluate 'Case 1: changing the owner of u1.tbl to u3 with change_owner() updates db_auth, db_authorization and db_class';
create table u1.tbl (col1 int);

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC'  order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u1.tbl', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name = 'tbl';

drop table u3.tbl;


evaluate 'Case 2: changing the owner of the view u1.v1_tbl to u2 and then to u3 with change_owner() updates db_auth, db_authorization and show create view';
create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;


call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;


call login(class db_user,'dba','');
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u1.v1_tbl', 'u2') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;


call login('dba','') on class db_user;
CALL change_owner ('u2.v1_tbl', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name ='v1_tbl';
show create view u3.v1_tbl;

call login(class db_user,'dba','');
drop table u1.tbl;
drop view u3.v1_tbl;


evaluate 'Case 3: u2 with EXECUTE cannot change the owner of the function u1.hello with change_sp_owner(), and dba can';
create function u1.hello() return string
as language java
name 'SpCubrid.HelloCubrid() return java.lang.String';

call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;

select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

call login('u2','') on class db_user;
-- expected to fail: u2 has EXECUTE but is not dba
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;

call login('u1','') on class db_user;
-- the owner u1 alters the comment of its function
ALTER FUNCTION u1.hello COMMENT 'aaaa';
select sp_name, owner, comment from db_stored_procedure;

call login('dba','') on class db_user;
CALL change_sp_owner ('u1.hello', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by 1,2,3;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select sp_name, owner from db_stored_procedure;

call login(class db_user,'dba','');
drop FUNCTION u3.hello;


evaluate 'Case 4: users with ALTER on a table, with or without grant option, cannot change its owner with change_owner(), and dba can';
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
-- expected to fail: u3 has ALTER but is not dba
CALL change_owner ('u1.tbl', 'u3') ON CLASS db_root;
CALL change_owner ('u1.tbl2', 'u3') ON CLASS db_root;


call login('u2','') on class db_user;
-- expected to fail: u2 has ALTER but is not dba
CALL change_owner ('u1.tbl', 'u3') ON CLASS db_root;
CALL change_owner ('u1.tbl2', 'u3') ON CLASS db_root;


call login('dba','') on class db_user;
CALL change_owner ('u1.tbl', 'u3') ON CLASS db_root;
CALL change_owner ('u1.tbl2', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name in ('tbl', 'tbl2') order by 1;

call login(class db_user,'dba','');
drop table u3.tbl;
drop table u3.tbl2;


evaluate 'Case 5: only dba changes the owner of range, hash and list partitioned tables with change_owner()';
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
-- expected to fail: u3 is not dba
CALL change_owner ('u1.t1_r', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_h', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_l', 'u3') ON CLASS db_root;


call login ('u2') on class db_user;
-- expected to fail: u2 is not dba
CALL change_owner ('u1.t1_r', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_h', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_l', 'u3') ON CLASS db_root;


call login ('dba') on class db_user;
-- dba changes the owners
CALL change_owner ('u1.t1_r', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_h', 'u3') ON CLASS db_root;
CALL change_owner ('u1.t1_l', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;
select class_name, owner_name from db_class where class_name in ('t1_r', 't1_h', 't1_l') order by 1;

drop table u3.t1_r;
drop table u3.t1_h;
drop table u3.t1_l;


evaluate 'Case 6: changing the owner of a table whose SELECT and INSERT grants chain between u2 and u3 updates db_auth and db_authorization';
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

CALL change_owner ('u1.tbl1', 'u3') ON CLASS db_root;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

drop table u3.tbl1;


evaluate 'Case 7: changing the owner of a table whose grants reach u4 through u2 and u3 updates db_auth and db_authorization';
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

CALL change_owner ('u1.tbl1', 'u3') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

drop table u3.tbl1;


evaluate 'Case 8: after the owner change, the grant options in db_authorization decide what u2 and u4 can grant, insert and select';
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
-- expected to fail: u2 has SELECT without grant option
GRANT SELECT ON u3.tbl1 TO u1;

insert into u3.tbl1 values(1);
select * from u3.tbl1 order by 1;


call login('u4','') on class db_user;
-- expected to fail: u4 has INSERT without grant option
GRANT INSERT ON u3.tbl1 TO U1;
-- u4 has SELECT with grant option
GRANT SELECT ON u3.tbl1 TO u1;

insert into u3.tbl1 values(2);
select * from u3.tbl1 order by 1;


call login('dba','') on class db_user;
drop table u3.tbl1;


evaluate 'Case 9: SELECT grants among u2 to u5 follow a chain of owner changes from u1 to u5, and a GRANT to the owner fails';
create table u1.tbl (col1 int);

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u2','') on class db_user;
-- expected to fail: u1 owns TBL
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
-- u2 grants to the other users
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u3','') on class db_user;
-- expected to fail: u1 owns TBL
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
-- u3 grants to the other users
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u4','') on class db_user;
-- expected to fail: u1 owns TBL
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
-- u4 grants to the other users
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u5','') on class db_user;
-- expected to fail: u1 owns TBL
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
-- u5 grants to the other users
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;


call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

CALL change_owner ('u1.TBL', 'u2') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

CALL change_owner ('u2.TBL', 'u3') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

CALL change_owner ('u3.TBL', 'u4') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by 1;

CALL change_owner ('u4.TBL', 'u5') ON CLASS db_root;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' ORDER BY grantor_name, grantee_name, object_name;

drop table u5.tbl;


-- cleanup
drop user u5;
drop user u4;
drop user u3;
drop user u2;
drop user u1;
