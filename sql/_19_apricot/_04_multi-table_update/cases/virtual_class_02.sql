set system parameters 'create_table_reuseoid=no';
--CLIENT
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int, j int);
insert into t3 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

create view v1 as select * from t1 where i >= 3;
create view v2 as select * from t2 where i <= 5 with check option;
create view v3 as select * from  t3 where i mod 2 = 0 with check option;

update v1 inner join v2 on v1.i=v2.i set v1.i=v1.i + 1, v2.i=v2.i - 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i set v1.i=v1.i + 1, v2.i=v2.i + 2;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;

update v1 inner join v2 on v1.i=v2.i inner join v3 on v2.i=v3.i set v3.i=v2.i, v1.i=v1.i + 1, v2.i=v2.i + 2;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from v1 order by 1;
select * from v2 order by 1;
select * from v3 order by 1;

drop view v1;
drop view v2;
drop view v3;
drop table t1;
drop table t2;
drop table t3;
set system parameters 'create_table_reuseoid=yes';
