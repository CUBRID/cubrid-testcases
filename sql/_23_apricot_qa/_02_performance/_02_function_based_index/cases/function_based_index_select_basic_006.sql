--+ holdcas on;
create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (floor(d1));

insert into t1 values (1,1,1.1,1,'1');
insert into t1 values (2,2,2.2,2,'2');
insert into t1 values (3,3,3.3,3,'3');
insert into t1 values (4,4,4.4,4,'4');
insert into t1 values (5,5,5.5,5,'5');
insert into t1 values (6,6,6.6,6,'6');
insert into t1 values (7,7,7.7,7,'7');
insert into t1 values (8,8,8.8,8,'8');
insert into t1 values (9,9,9.9,9,'9');

--test
select /*+ recompile */ * from t1 where floor(d1) > 3;

--test
select /*+ recompile */ * from t1 where floor(d1) = 3;

--test
select /*+ recompile */ * from t1 where floor(d1) < 4 and floor(d1) > 2;

--test
select /*+ recompile */ * from t1 where d1 > 3;

drop index idx on t1;

create index idx on t1 (floor(d1));

--test
select /*+ recompile */ * from t1 where floor(d1) > 3;

--test
select /*+ recompile */ * from t1 where floor(d1) = 3;

--test
select /*+ recompile */ * from t1 where floor(d1) < 4 and floor(d1) > 2;

--test
select /*+ recompile */ * from t1 where d1 > 3;


drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, floor(d1));

insert into t1 values (1,1,1.1,1,'1');
insert into t1 values (2,2,2.2,2,'2');
insert into t1 values (3,3,3.3,3,'3');
insert into t1 values (4,3,4.4,4,'4');
insert into t1 values (5,3,5.5,5,'5');
insert into t1 values (6,3,6.6,6,'6');
insert into t1 values (7,3,7.7,7,'7');
insert into t1 values (8,3,8.8,8,'8');
insert into t1 values (9,3,9.9,9,'9');

--test
select /*+ recompile */ * from t1 where i2 = 3 and floor(d1) > 5;

--test
select /*+ recompile */ * from t1 where i2 = 3 and floor(d1) > 5 and floor(d1) < 8;

--test
select /*+ recompile */ * from t1 where i2 > 2 and d1 > 3;

--test
select /*+ recompile */ * from t1 where d1 > 3;

drop index idx on t1;

create index idx on t1 (i2, floor(d1));

--test
select /*+ recompile */ * from t1 where i2 = 3 and floor(d1) > 5;

--test
select /*+ recompile */ * from t1 where i2 = 3 and floor(d1) > 5 and floor(d1) < 8;

--test
select /*+ recompile */ * from t1 where i2 > 2 and d1 > 3;

--test
select /*+ recompile */ * from t1 where d1 > 3;


drop index idx on t1;

drop table t1;


commit;
--+ holdcas off;
