--CLIENT
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int, j int);
insert into t3 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

create view v1 as select * from t1 where i >= 3;
create view v2 as select * from t2 where i <= 5;
create view v3 as select t1.i as i1, t3.i as i3 from t1 inner join t3 on t1.i=t3.i;

update v1 inner join v2 on v1.i=v2.i set v2.i=v2.i + 1, v1.i=v2.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

update v2 inner join v3 on v2.i=v3.i1 set v2.i=v2.i + 1, v3.i1=v3.i3 + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i inner join t3 on v2.i=t3.i set v1.i=t3.j + 1, t3.j=v2.i + 1, v2.i =v1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

drop view v1;
drop view v2;
drop view v3;
drop table t1;
drop table t2;
drop table t3;