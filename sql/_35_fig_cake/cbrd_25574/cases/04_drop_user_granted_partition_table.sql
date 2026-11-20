/**
 *  This test case verifies CBRD-25574: DROP USER removes the rows of the dropped user from
 *  db_auth and from the grants of db_authorization, instead of leaving them with NULL.
 *
 *  The dropped user u2 holds grants on range, hash and list partitioned tables of u1.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on t1_r and t1_h and SELECT, ALTER on t1_l to u2
 *    Case 2:  a GRANT on the partition t1_l__p__p1 fails with an error, and the catalogs show only the grants of Case 1
 *    Case 3:  after DROP USER u2, the rows granted to u2 are gone
 */

create user u1;
create user u2;

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

evaluate 'Case 2: a GRANT on the partition t1_l__p__p1 fails with an error, and the catalogs show only the grants of Case 1';
grant insert on t1_l__p__p1 to u2 with grant option;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by object_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 3: after DROP USER u2, the rows granted to u2 are gone';
call login ('dba') on class db_user;

drop user u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC';

select owner, grants from db_authorization where owner != 'PUBLIC';


drop table u1.t1_r;
drop table u1.t1_h;
drop table u1.t1_l;
drop user u1;
