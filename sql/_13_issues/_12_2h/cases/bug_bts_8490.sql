set system parameters 'create_table_reuseoid=no';
drop table if exists t1;

create table t1(i int, j int);
insert into t1 values (1, 1), (2, 2), (3, 3);
create view v1 as select * from t1 where i > 1;

select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

update t1 left join v1 on t1.i=v1.i set v1.i=7;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

update v1 right join t1 on t1.i=v1.i set v1.i=8;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;

create table t1(i bigint, j bigint) partition by hash(i) partitions 3; ;
insert into t1 values (1, 1), (2, 2), (3, 3);
create view v1 as select * from t1 where i > 1;

select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

update t1 left join v1 on t1.i=v1.i set v1.i=7;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

update v1 right join t1 on t1.i=v1.i set v1.i=8;
select * from t1 order by 1, 2;
select * from v1 order by 1, 2;

drop view v1;
drop table t1;
set system parameters 'create_table_reuseoid=yes';
