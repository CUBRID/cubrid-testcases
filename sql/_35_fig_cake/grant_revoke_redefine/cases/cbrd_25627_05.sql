/* Verfified the CBRD-25627
As-is: if changed the owner of objects then it is not updated on db_auth
To-be: If changed the owner of objects then revoke all grantors
*/



create user u1;
create user u2;
create user u3;

evaluate 'case 5: changed owner for partition table';

evaluate 'connect to u1 & create u1.t1_r, u1.t1_h, u1.t1_l partition table';
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

evaluate 'u1.t1_r, u1.t1_h, u1.t1_l grant to u2';
grant select on t1_r to u2 with grant option;
grant select on t1_h to u2 with grant option;

evaluate 'ERROR: Invalid partition requests';
grant select on t1_l__p__p0 to u2 with grant option;

grant select on t1_l to u2 with grant option;


select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'connect to u2 & u1.t1_r, u1.t1_h, u1.t1_l grant to u3';
call login ('u2') on class db_user;

grant select on u1.t1_r to u3 with grant option;
grant select on u1.t1_h to u3 with grant option;
grant select on u1.t1_l to u3 with grant option;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'connect to u3 & changed owner, ERROR: can only be performed by the DBA or a DBA group member';
call login ('u3') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;


evaluate 'connect to u2 & changed owner, ERROR: can only be performed by the DBA or a DBA group member';
call login ('u2') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;

evaluate 'connect to dba & changed owner u1.t1_r, u1.t1_h, u1.t1_l -> u3.t1_r, u3.t1_h, u3.t1_l';
call login ('dba') on class db_user;
ALTER TABLE u1.t1_r OWNER TO u3;
ALTER TABLE u1.t1_h OWNER TO u3;
ALTER TABLE u1.t1_l OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select class_name, owner_name from db_class where class_name in ('t1_r', 't1_h', 't1_l') order by class_name;


evaluate 'Test init';
call login(class db_user,'dba','');
drop table u3.t1_r;
drop table u3.t1_h;
drop table u3.t1_l;
drop user u1;
drop user u2;
drop user u3;