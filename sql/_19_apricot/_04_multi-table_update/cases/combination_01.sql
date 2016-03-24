--CLIENT
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2 under t1 (j int);
insert into t2 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

create view v1 as select * from t1 where t1.i >= 1;
create view v2 under v1 as select t1.i from t1 where t1.i <= 5;

update all t1 set t1.i = t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

update all v1 inner join all t1 on v1.i=t1.i set v1.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

drop view v2;
drop view v1;
drop table t2;
drop table t1;