/* create table - check if the identifier name includes a dot(.). */

create user u1;
call login ('u1') on class db_user;
create table u1.t1 (c1 int, c2 varchar, c3 datetime);
create table u1.t1.t1 (c1 int, c2 varchar, c3 datetime);
create table [t2.t2] (c1 int, c2 varchar, c3 datetime);
create table "t3.t3" (c1 int, c2 varchar, c3 datetime);
create table `t4.t4` (c1 int, c2 varchar, c3 datetime);

call login ('u1') on class db_user;
drop table t1;
call login ('dba') on class db_user;
drop user u1;
