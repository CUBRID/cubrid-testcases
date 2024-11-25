/* Verified the CBRD-25574
As-is: if dropped user then set 'NULL' related data on the db_auth, db_authorization table
To-be: if dropped user then remove the related data on the db_auth, db_authorization table
*/

create user u1;
create user u2;

evaluate 'connect to u1 & create partition table t1_r, t1_h, t1_l';
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

evaluate 'u2 grant to t1_r, t1_h, t1_l';
grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;
grant select, alter on t1_l to u2 with grant option;

evaluate 'ERROR: Invalid partition requests';
grant insert on t1_l__p__p1 to u2 with grant option;

select * from db_auth where grantee_name != 'PUBLIC' order by object_name, auth_type;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to dba & drop user u2';
call login ('dba') on class db_user;

drop user u2;

select * from db_auth where grantee_name != 'PUBLIC';

select owner.name, grants from db_authorization where owner.name != 'PUBLIC';


evaluate 'Test done';
drop table u1.t1_r;
drop table u1.t1_h;
drop table u1.t1_l;
drop user u1;