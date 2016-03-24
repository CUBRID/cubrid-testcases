--CLIENT
create table t1(i int);
create view v1 as select * from t1 where i < 5 with check option;
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
create view v2 as select * from t2 where i > 2 with check option;
insert into t2 values (2), (3), (4), (5), (6);

create view v3 as select * from v2 where i < 6 with check option;

create table t3(i int);
insert into t3 values (3), (4), (5), (6), (7);

update v3 set i=i + 1;
select * from t1 order by 1;
select * from v1 order by 1;
select * from t2 order by 1;
select * from v2 order by 1;
select * from v3 order by 1;
select * from t3 order by 1;

update v3 set i=i - 1;
select * from t1 order by 1;
select * from v1 order by 1;
select * from t2 order by 1;
select * from v2 order by 1;
select * from v3 order by 1;
select * from t3 order by 1;

update v1 inner join  t3 on v1.i=t3.i inner join v2 on t3.i=v2.i set t3.i=t3.i + 1, v2.i=v2.i + 1, v1.i=v1.i + 1 where t3.i=4;
select * from t1 order by 1;
select * from v1 order by 1;
select * from t2 order by 1;
select * from v2 order by 1;
select * from v3 order by 1;
select * from t3 order by 1;

update v1 inner join  t3 on v1.i=t3.i inner join v3 on t3.i=v3.i set t3.i=t3.i - 1, v3.i=v3.i - 1, v1.i=v1.i - 1 where t3.i=3;
select * from t1 order by 1;
select * from v1 order by 1;
select * from t2 order by 1;
select * from v2 order by 1;
select * from v3 order by 1;
select * from t3 order by 1;

drop view v3;
drop view v1;
drop table t1;
drop view v2;
drop table t2;
drop table t3;