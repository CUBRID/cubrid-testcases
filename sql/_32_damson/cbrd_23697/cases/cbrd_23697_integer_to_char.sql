drop if exists t1;

create table t1 (a int, b char(3));

insert into t1 values(1, 'ab');

update t1 set b = 1 where a = 1;
update t1 set b = 'abc' where a = 1;

select * from t1 order by a;

drop table t1;

create table t1 (a int, b char(3));

insert into t1 values(1, 'ab');

update t1 set b = 1 where a = 1;
update /*+ recompile */ t1 set b = 'abc' where a = 1;

select * from t1 order by a;

drop table t1;

create table t1 (a int, b char(10));

insert into t1 values(1, 'ab');

update t1 set b = 1 where a = 1;
update t1 set b = 'abc' where a = 1;

select * from t1 order by a;

drop table t1;

create table t1 (a int, b char(10));

insert into t1 values(1, 'ab');

update t1 set b = 1 where a = 1;
update /*+ recompile */ t1 set b = 'abc' where a = 1;

select * from t1 order by a;

drop table t1;

