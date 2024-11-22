/* Verified the CBRD-25486
As-is: if removed the object then remove the related data on the db_authorization table
To-be: if removed the object then set 'NULL' relate data on the db_authorization table

Scenario 05: Drop partition table from granted alter permission users
*/

create user u1;
create user u2;
create user u3;

evaluate 'connect u1, create u1.t1_r, u1.t1_h, u1.t1_l (partition table)';
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

evaluate 'u2 grant to u1.t1_r, u1.t1_h, u1.t1_l';
grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;
grant select, alter on t1_l to u2 with grant option;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to u2 & u3 grant to u1.t1_r, u1.t1_h, u1.t1_l';
call login ('u2') on class db_user;

grant select on u1.t1_r to u3 with grant option;
grant select on u1.t1_h to u3 with grant option;
grant select, alter on u1.t1_l to u3 with grant option;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect u3, drop table u1.t1_r, u1.t1_h, u1.t1_l';
call login ('u3') on class db_user;

evaluate 'ERROR: ALTER authorization failure';
drop table u1.t1_h;
drop table u1.t1_r;

evaluate 'success: drop u1.t1_l';
drop table u1.t1_l;

evaluate 'success: drop u1.t1_l';
select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to u2, drop table u1.t1_r, u1.t1_h';
call login(class db_user,'u2','');

evaluate 'ERROR: ALTER authorization failure';
drop table u1.t1_h;
drop table u1.t1_r;


evaluate 'connect to u1, drop u1.t1_h';
call login(class db_user,'u1','');

drop table u1.t1_h;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'connect to dba, drop u1.t1_r';
call login(class db_user,'dba','');

drop table u1.t1_r;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name;


evaluate 'Test done';
drop user u1;
drop user u2;
drop user u3;