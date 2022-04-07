/* create table with like - check if the identifier name includes a dot(.). */

create user u1;
call login ('u1') on class db_user;
create table u1.t1 (c1 int primary key, c2 varchar, c3 datetime);
create table u1.tt1 like t1;

create table u1.tt2.tt2 like t1;
create table [tt3.tt3] like t1;
create table "tt4.tt4" like t1;
create table `tt5.tt5` like t1;

call login ('u1') on class db_user;
drop table tt1;
drop table t1;
call login ('dba') on class db_user;
drop user u1;
