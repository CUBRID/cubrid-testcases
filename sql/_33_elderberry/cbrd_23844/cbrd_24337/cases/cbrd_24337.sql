drop table if exists t1;

call login ('dba') on class db_user;
create user u1;
create table _db_class;
create table dba._db_class;
create table u1._db_class;
create table t1 (c1 int);

rename table t1 to _db_class;
rename table t1 to dba._db_class;
rename table t1 to u1._db_class;

call login ('u1') on class db_user;
create table _db_class;
create table dba._db_class;
create table u1._db_class;
create table t1 (c1 int);

rename table t1 to _db_class;
rename table t1 to dba._db_class;
rename table t1 to u1._db_class;

drop table t1;
call login ('dba') on class db_user;
drop user u1;
