--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (cos(d1));

insert into t1 values (1,1,1,1,'1');
insert into t1 values (2,2,2,2,'2');
insert into t1 values (3,3,3,3,'3');
insert into t1 values (4,4,4,4,'4');
insert into t1 values (5,5,4,5,'5');
insert into t1 values (6,6,6,6,'6');
insert into t1 values (7,7,7,7,'7');
insert into t1 values (8,8,8,8,'8');
insert into t1 values (9,9,9,9,'9');

--Test
select /*+ recompile */ * from t1 where cos(d1) > cos(3);

--Test
select /*+ recompile */ * from t1 where cos(d1) = cos(3);

--Test
select /*+ recompile */ * from t1 where cos(d1) < cos(4) and cos(d1) > cos(2);

--Test
select /*+ recompile */ * from t1 where d1 > 3;

drop index idx on t1;

create index idx on t1 (cos(d1));

--Test
select /*+ recompile */ * from t1 where cos(d1) > cos(3);

--Test
select /*+ recompile */ * from t1 where cos(d1) = cos(3);

--Test
select /*+ recompile */ * from t1 where cos(d1) < cos(4) and cos(d1) > cos(2);

--Test
select /*+ recompile */ * from t1 where d1 > 3;

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, cos(d1));

insert into t1 values (1,1,1,1,'1');
insert into t1 values (2,2,2,2,'2');
insert into t1 values (3,3,3,3,'3');
insert into t1 values (4,4,4,4,'4');
insert into t1 values (5,5,4,5,'5');
insert into t1 values (6,6,6,6,'6');
insert into t1 values (7,7,7,7,'7');
insert into t1 values (8,8,8,8,'8');
insert into t1 values (9,9,9,9,'9');

--Test
select /*+ recompile */ * from t1 where i2 = 3 and cos(d1) > cos(5);

--Test
select /*+ recompile */ * from t1 where i2 = 3 and cos(d1) > cos(5) and cos(d1) < cos(8);

--Test
select /*+ recompile */ * from t1 where i2 > 2 and d1 > 3;

--Test
select /*+ recompile */ * from t1 where d1 > 3;

drop index idx on t1;

create index idx on t1 (i2, cos(d1));

--Test
select /*+ recompile */ * from t1 where i2 = 3 and cos(d1) > cos(5);

--Test
select /*+ recompile */ * from t1 where i2 = 3 and cos(d1) > cos(5) and cos(d1) < cos(8);

--Test
select /*+ recompile */ * from t1 where i2 > 2 and d1 > 3;

--Test
select /*+ recompile */ * from t1 where d1 > 3;


drop index idx on t1;

drop table t1;


set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
