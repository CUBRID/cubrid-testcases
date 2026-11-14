/**
 *  This test case verifies CBRD-25627: changing the owner of an object updates db_auth. The
 *  new owner becomes the grantor of the grants that stay, and a grant to the new owner itself
 *  is removed.
 *
 *  This file changes the owner of range, hash and list partitioned tables, whose partitions
 *  have db_auth rows of their own.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on the three tables to u2, and a GRANT on the partition t1_l__p__p0 fails with an error
 *    Case 2:  u2 grants SELECT on the three tables to u3
 *    Case 3:  u3 fails to change the owners with an error, only dba or the dba group can
 *    Case 4:  u2 fails to change the owners with an error
 *    Case 5:  after dba changes the owners to u3, u3 is the grantor to u2 for the tables and partitions, and the grants to u3 are gone
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

evaluate 'Case 1: u1 grants SELECT on the three tables to u2, and a GRANT on the partition t1_l__p__p0 fails with an error';
grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;

grant select on t1_l__p__p0 to u2 with grant option;

grant select on t1_l to u2 with grant option;


select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'Case 2: u2 grants SELECT on the three tables to u3';
call login ('u2') on class db_user;

grant select on u1.t1_r to u3 with grant option;
grant select on u1.t1_h to u3 with grant option;
grant select on u1.t1_l to u3 with grant option;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'Case 3: u3 fails to change the owners with an error, only dba or the dba group can';
call login ('u3') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;


evaluate 'Case 4: u2 fails to change the owners with an error';
call login ('u2') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;

evaluate 'Case 5: after dba changes the owners to u3, u3 is the grantor to u2 for the tables and partitions, and the grants to u3 are gone';
call login ('dba') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select class_name, owner_name from db_class where class_name in ('t1_r', 't1_h', 't1_l') order by class_name;


call login(class db_user,'dba','');
drop table u3.t1_r;
drop table u3.t1_h;
drop table u3.t1_l;
drop user u1;
drop user u2;
drop user u3;
