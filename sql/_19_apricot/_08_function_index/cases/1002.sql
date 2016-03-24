create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (right(s, 3));

insert into t1 values (11,11,11,11,'11111');
insert into t1 values (22,22,22,22,'22222');
insert into t1 values (33,33,33,33,'33333');
insert into t1 values (44,44,44,44,'44444');
insert into t1 values (55,55,55,55,'55555');
insert into t1 values (66,66,66,66,'66666');
insert into t1 values (77,77,77,77,'77777');
insert into t1 values (88,88,88,88,'88888');
insert into t1 values (99,99,99,99,'99999');


select /*+ recompile */ * from t1 where right(s, 3) > '333' order by 1;


select /*+ recompile */ * from t1 where right(s, 3) = '333';


select /*+ recompile */ * from t1 where right(s, 3) < '444' and right(s, 3) > '222';


select /*+ recompile */ * from t1 where s > '333' order by 1,2,3,4,5;

drop index idx on t1;

create index idx on t1 (right(s, 3));


select /*+ recompile */ * from t1 where right(s, 3) > '333' order by 1;


select /*+ recompile */ * from t1 where right(s, 3) = '333';


select /*+ recompile */ * from t1 where right(s, 3) < '444' and right(s, 3) > '222';


select /*+ recompile */ * from t1 where s > '333' order by 1,2,3,4,5;

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, right(s, 3));

insert into t1 values (11,11,11,11,'11111');
insert into t1 values (22,22,22,22,'22222');
insert into t1 values (33,33,33,33,'33333');
insert into t1 values (44,33,44,44,'33333');
insert into t1 values (55,33,55,55,'33333');
insert into t1 values (66,33,66,66,'33333');
insert into t1 values (77,33,77,77,'33333');
insert into t1 values (88,33,88,88,'33333');
insert into t1 values (99,33,99,99,'33333');


select /*+ recompile */ * from t1 where i2 = 33 and right(s, 3) > '555';


select /*+ recompile */ * from t1 where i2 = 33 and right(s, 3) > '555' and right(s, 3) < '888';


select /*+ recompile */ * from t1 where i2 > 22 and i1 > 33 order by 1;


select /*+ recompile */ * from t1 where i1 > 33 order by 1,2,3,4,5;

drop index idx on t1;

create index idx on t1 (i2, right(s, 3));


select /*+ recompile */ * from t1 where i2 = 33 and right(s, 3) > '555';


select /*+ recompile */ * from t1 where i2 = 33 and right(s, 3) > '555' and right(s, 3) < '888';


select /*+ recompile */ * from t1 where i2 > 22 and i1 > 33 order by 1;


select /*+ recompile */ * from t1 where i1 > 33 order by 1,2,3,4,5;


drop index idx on t1;

drop table t1;

