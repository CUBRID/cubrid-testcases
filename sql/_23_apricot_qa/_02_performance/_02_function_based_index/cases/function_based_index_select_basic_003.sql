--+ holdcas on;
create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (mod(i1, 10));

insert into t1 values (11,11,11,11,'1');
insert into t1 values (22,22,22,22,'2');
insert into t1 values (33,33,33,33,'3');
insert into t1 values (44,44,44,44,'4');
insert into t1 values (55,55,55,55,'5');
insert into t1 values (66,66,66,66,'6');
insert into t1 values (77,77,77,77,'7');
insert into t1 values (88,88,88,88,'8');
insert into t1 values (99,99,99,99,'9');

--test
select /*+ recompile */ * from t1 where mod(i1,10) > 3;

--test
select /*+ recompile */ * from t1 where mod(i1,10) = 3;
--test

select /*+ recompile */ * from t1 where mod(i1,10) < 4 and mod(i1, 10) > 2;

--test
select /*+ recompile */ * from t1 where i1 > 33;
--test
drop index idx on t1;
--test
create index idx on t1 (mod(i1,10));

--test
select /*+ recompile */ * from t1 where mod(i1,10) > 3;
--test

select /*+ recompile */ * from t1 where mod(i1,10) = 3;

--test
select /*+ recompile */ * from t1 where mod(i1,10) < 4 and mod(i1, 10) > 2;

--test
select /*+ recompile */ * from t1 where i1 > 33;

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, mod(i1,10));

insert into t1 values (11,11,11,11,'1');
insert into t1 values (22,22,22,22,'2');
insert into t1 values (33,33,33,33,'3');
insert into t1 values (44,33,44,44,'4');
insert into t1 values (55,33,55,55,'5');
insert into t1 values (66,33,66,66,'6');
insert into t1 values (77,33,77,77,'7');
insert into t1 values (88,33,88,88,'8');
insert into t1 values (99,33,99,99,'9');

--test
select /*+ recompile */ * from t1 where i2 = 33 and mod(i1,10) > 5;

--test
select /*+ recompile */ * from t1 where i2 = 33 and mod(i1,10) > 5 and mod(i1,10) < 8;

--test
select /*+ recompile */ * from t1 where i2 > 22 and i1 > 33;

--test
select /*+ recompile */ * from t1 where i1 > 33;

drop index idx on t1;

create index idx on t1 (i2, mod(i1,10));

--test
select /*+ recompile */ * from t1 where i2 = 33 and mod(i1,10) > 5;

--test
select /*+ recompile */ * from t1 where i2 = 33 and mod(i1,10) > 5 and mod(i1,10) < 8;

--test
select /*+ recompile */ * from t1 where i2 > 22 and i1 > 33;

--test
select /*+ recompile */ * from t1 where i1 > 33;

drop index idx on t1;

drop table t1;


commit;
--+ holdcas off;
