/*
 *      14. Alias
 */

create user u1;
create user u2;
create table t1 (c1 int);
create table t2 (c2 int);
insert into t1 values (1);
insert into t2 values (2);
call login ('u1') on class db_user;
create table t1 (c1 int);
create table t2 (c1 int);
insert into t1 values (1);
insert into t2 values (1);
call login ('u2') on class db_user;
create table t1 (c2 int);
create table t2 (c1 int);
insert into t1 values (2);
insert into t2 values (2);
call login ('dba') on class db_user;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select c1, c2 from t1, t2;
select c1, c2 from u1.t1, u2.t1;
select c1 from u1.t2, u2.t2;
select [u1.t2].c1, [u2.t2].c1 from u1.t2, u2.t2;
select a.c1, b.c1 from u1.t2 a, u2.t2 b;

drop table u2.t2;
drop table u2.t1;
drop table u1.t2;
drop table u1.t1;
drop table t2;
drop table t1;
drop user u2;
drop user u1;
