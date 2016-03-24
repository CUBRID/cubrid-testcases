create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (rtrim(s));

insert into t1 values (1,1,1,1,'aaa   ');
insert into t1 values (2,2,2,2,'bbb   ');
insert into t1 values (3,3,3,3,'ccc   ');
insert into t1 values (4,4,4,4,'ddd   ');
insert into t1 values (5,5,4,5,'eee   ');
insert into t1 values (6,6,6,6,'fff   ');
insert into t1 values (7,7,7,7,'ggg   ');
insert into t1 values (8,8,8,8,'hhh   ');
insert into t1 values (9,9,9,9,'iii   ');


select /*+ recompile */ * from t1 where rtrim(s) > 'ccc';


select /*+ recompile */ * from t1 where rtrim(s) = 'ccc';


select /*+ recompile */ * from t1 where rtrim(s) < 'ddd' and rtrim(s) > 'bbb';


select /*+ recompile */ * from t1 where s > 'ccc' order by i1;

drop index idx on t1;

create index idx on t1 (rtrim(s));


select /*+ recompile */ * from t1 where rtrim(s) > 'ccc';


select /*+ recompile */ * from t1 where rtrim(s) = 'ccc';


select /*+ recompile */ * from t1 where rtrim(s) < 'ddd' and rtrim(s) > 'bbb';


select /*+ recompile */ * from t1 where s > 'ccc' order by i1;

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, rtrim(s));

insert into t1 values (1,1,1,1,'aaa   ');
insert into t1 values (2,2,2,2,'bbb   ');
insert into t1 values (3,3,3,3,'ccc   ');
insert into t1 values (4,3,4,4,'ddd   ');
insert into t1 values (5,3,4,5,'eee   ');
insert into t1 values (6,3,6,6,'fff   ');
insert into t1 values (7,3,7,7,'ggg   ');
insert into t1 values (8,3,8,8,'hhh   ');
insert into t1 values (9,3,9,9,'iii   ');


select /*+ recompile */ * from t1 where i2 = 3 and rtrim(s) > 'eee';


select /*+ recompile */ * from t1 where i2 = 3 and rtrim(s) > 'eee' and rtrim(s) < 'hhh';


select /*+ recompile */ * from t1 where i2 > 2 and s > 'ccc';


select /*+ recompile */ * from t1 where s > 'ccc' order by i1;

drop index idx on t1;

create index idx on t1 (i2, rtrim(s));


select /*+ recompile */ * from t1 where i2 = 3 and rtrim(s) > 'eee';


select /*+ recompile */ * from t1 where i2 = 3 and rtrim(s) > 'eee' and rtrim(s) < 'hhh';


select /*+ recompile */ * from t1 where i2 > 2 and s > 'ccc';


select /*+ recompile */ * from t1 where s > 'ccc' order by i1;


drop index idx on t1;

drop table t1;

