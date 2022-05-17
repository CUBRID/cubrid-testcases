/* Test 1: use of synoym by multiple users */
create user u1;
create user u2;
create user u3;
create user u21 members u2;
create user u31 members u3;

select * from db_synonym;

call login ('u1') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u1', 1);
create synonym s1 for t1;

call login ('u2') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u2', 1);
create synonym s1 for t1;

call login ('u3') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u3', 1);
create synonym s1 for t1;

call login ('u21') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u21 (member of u2)', 1);
create synonym s1 for t1;

call login ('u31') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u31 (member of u3)', 1);
create synonym s1 for t1;

call login ('dba') on class db_user;
select class_name, owner_name from db_class where is_system_class = upper ('NO');
select * from _db_synonym order by 1;

call login ('u1') on class db_user;
select * from s1;

call login ('u2') on class db_user;
select * from s1;

call login ('u3') on class db_user;
select * from s1;

call login ('u21') on class db_user;
select * from s1;

call login ('u31') on class db_user;
select * from s1;

/*
 * In oracle, if the user has permission for the target object, synonyms of other schemas can be used.
 *
 */
call login ('dba') on class db_user;
select * from u1.s1;
select * from u2.s1;
select * from u3.s1;
select * from u21.s1;
select * from u31.s1;

call login ('u2') on class db_user;
select * from u21.s1;
--err case
select * from u1.s1;
select * from u3.s1;
select * from u31.s1;

call login ('dba') on class db_user;
drop synonym u1.s1;
drop synonym u2.s1;
drop synonym u3.s1;
drop synonym u21.s1;
drop synonym u31.s1;
drop table u1.t1;
drop table u2.t1;
drop table u3.t1;
drop table u21.t1;
drop table u31.t1;
drop user u21;
drop user u31;
drop user u1;
drop user u2;
drop user u3;

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

