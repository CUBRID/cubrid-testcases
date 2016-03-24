--CLIENT
create table t1(i int);
create view v1 as select * from t1 where i < 5 with check option;
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
create view v2 as select * from t2 where i > 2 with check option;
insert into t2 values (2), (3), (4), (5), (6);

update v1 inner join v2 on v1.i=v2.i set v1.i=v2.i + 1, v2.i=v1.i + 1 where v1.i < 4;
select * from t1 order by 1;
select * from v1 order  by 1;
select * from t2 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i set v1.i=v2.i + 1, v2.i=v1.i + 1;
select * from t1 order by 1;
select * from v1 order  by 1;
select * from t2 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i set v1.i=v2.i - 2, v2.i=v1.i - 2;
select * from t1 order by 1;
select * from v1 order  by 1;
select * from t2 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i set v1.i=v2.i + 1, v2.i=v1.i + 1 where v1.i > 2;
select * from t1 order by 1;
select * from v1 order  by 1;
select * from t2 order by 1;
select * from v2 order by 1;

drop view v1;
drop table t1;
drop view v2;
drop table t2;