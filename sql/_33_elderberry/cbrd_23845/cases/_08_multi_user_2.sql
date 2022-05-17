/* Test 3: Use of the same synonym name for different users */
call login ('dba') on class db_user;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop synonym if exists s1;

create table t1 (c1 int);
create table t2 (c1 int);
create table t3 (c1 int);
create table t4 (c1 int);
create table t5 (c1 int);
create synonym s1 for db_class;
create user u1;

call login ('u1') on class db_user;
drop synonym if exists s1;
create synonym s1 for db_class;
select count(*) from s1;
select count(*) from dba.s1;

call login ('dba') on class db_user;
select count(*) from s1;
select count(*) from u1.s1;

call login ('dba') on class db_user;
drop synonym if exists u1.s1;
drop synonym if exists s1;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop user u1; 

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

