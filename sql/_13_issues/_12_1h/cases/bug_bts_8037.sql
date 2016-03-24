
drop table if exists t1;
create table t1(a1 varchar(2) default USER, b int);
insert into t1(b) values (1);
select * from t1 order by 1;
drop t1;
create table t1(a1 varchar(1) default USER, b int);
insert into t1(b) values (1);
select * from t1 order by 1;
drop t1;
create table t1(a1 STRING default USER, b int);
insert into t1(b) values (1);
select * from t1 order by 1;
drop t1;
create table t1(a1 STRING default USER, b int) partition by hash(a1) partitions 3;
insert into t1(b) values (1);
select * from t1 order by 1;
drop t1;
create table t1(a1 STRING default USER, b int) partition by hash(a1) partitions 3;
insert into t1(b) select null from db_class,db_class b limit 100;
select * from t1 order by 1;
delete from t1 where a1='DBA';

drop t1;
create table t1(a1 STRING default USER,a2 STRING default USER,a3 STRING default USER(), b int) partition by hash(a1) partitions 3;
insert into t1(b) select null from db_class,db_class b limit 100;
select a1, a2, if(length (a3) > length(a1), 'ok', 'nok') as ok_nok, b from t1 order by 1;
delete from t1 where a1='DBA';
drop t1;
