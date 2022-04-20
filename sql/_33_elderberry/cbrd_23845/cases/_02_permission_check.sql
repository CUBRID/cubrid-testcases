/*
 * check permission
 *
 */

call login ('public') on class db_user;
--err case
select * from _db_synonym;
--success case
select * from db_synonym;

call login ('dba') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;

--drop user u1;
create user u1 groups dba;
call login ('u1') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;

call login ('dba') on class db_user;
--drop user u2;
create user u2 groups u1;
call login ('u2') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;

call login ('dba') on class db_user;
--drop user u3;
create user u3;
call login ('u3') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;

call login ('dba') on class db_user;
--drop user u4;
create user u4 groups u3;
call login ('u4') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;

call login ('dba') on class db_user;
--drop user u5;
create user u5;
call login ('u5') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
create synonym s1 for t1;


call login ('dba') on class db_user;
select * from db_synonym;

call login ('u1') on class db_user;
select * from db_synonym;

call login ('u2') on class db_user;
select * from db_synonym;

call login ('u3') on class db_user;
select * from db_synonym;

call login ('u4') on class db_user;
select * from db_synonym;

call login ('u5') on class db_user;
select * from db_synonym;

call login ('dba') on class db_user;
drop synonym u1.s1;
drop synonym u2.s1;
drop synonym u3.s1;
drop synonym u4.s1;
drop synonym u5.s1;
drop synonym dba.s1;
drop table u1.t1;
drop table u2.t1;
drop table u3.t1;
drop table u4.t1;
drop table u5.t1;
drop table dba.t1;
drop user u1;
drop user u2;
drop user u3;
drop user u4;
drop user u5;
