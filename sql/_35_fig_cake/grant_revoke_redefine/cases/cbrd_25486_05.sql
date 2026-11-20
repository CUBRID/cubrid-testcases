/**
 *  This test case verifies CBRD-25486: dropping an object that is granted to other users
 *  removes its rows from db_auth and its entries from the grants of db_authorization.
 *
 *  Scenario 05 drops range, hash and list partitioned tables of u1 as a grantee with ALTER,
 *  as the owner and as dba.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on t1_r and t1_h and SELECT, ALTER on t1_l to u2
 *    Case 2:  u2 grants the same privileges to u3
 *    Case 3:  u3, which has no ALTER on t1_h and t1_r, fails to drop them with an error
 *    Case 4:  u3 drops u1.t1_l, and its grant rows are gone
 *    Case 5:  u2, which has no ALTER on t1_h and t1_r, fails to drop them with an error
 *    Case 6:  the owner u1 drops u1.t1_h, and its grant rows are gone
 *    Case 7:  dba drops u1.t1_r, and its grant rows are gone
 */

create user u1;
create user u2;
create user u3;

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

evaluate 'Case 1: u1 grants SELECT on t1_r and t1_h and SELECT, ALTER on t1_l to u2';
grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;
grant select, alter on t1_l to u2 with grant option;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 2: u2 grants the same privileges to u3';
call login ('u2') on class db_user;

grant select on u1.t1_r to u3 with grant option;
grant select on u1.t1_h to u3 with grant option;
grant select, alter on u1.t1_l to u3 with grant option;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 3: u3, which has no ALTER on t1_h and t1_r, fails to drop them with an error';
call login ('u3') on class db_user;

drop table u1.t1_h;
drop table u1.t1_r;

evaluate 'Case 4: u3 drops u1.t1_l, and its grant rows are gone';
drop table u1.t1_l;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 5: u2, which has no ALTER on t1_h and t1_r, fails to drop them with an error';
call login(class db_user,'u2','');

drop table u1.t1_h;
drop table u1.t1_r;


evaluate 'Case 6: the owner u1 drops u1.t1_h, and its grant rows are gone';
call login(class db_user,'u1','');

drop table u1.t1_h;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 7: dba drops u1.t1_r, and its grant rows are gone';
call login(class db_user,'dba','');

drop table u1.t1_r;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


drop user u1;
drop user u2;
drop user u3;
