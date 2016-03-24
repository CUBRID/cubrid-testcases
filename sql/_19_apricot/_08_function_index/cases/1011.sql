create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (lower(s));

insert into t1 values (1,1,1,1,'AAA');
insert into t1 values (2,2,2,2,'BBB');
insert into t1 values (3,3,3,3,'CCC');
insert into t1 values (4,4,4,4,'DDD');
insert into t1 values (5,5,4,5,'EEE');
insert into t1 values (6,6,6,6,'FFF');
insert into t1 values (7,7,7,7,'GGG');
insert into t1 values (8,8,8,8,'HHH');
insert into t1 values (9,9,9,9,'III');


select /*+ recompile */ * from t1 where lower(s) > 'ccc';


select /*+ recompile */ * from t1 where lower(s) = 'ccc';


select /*+ recompile */ * from t1 where lower(s) < 'ddd' and lower(s) > 'bbb';


select /*+ recompile */ * from t1 where s > 'ccc';

drop index idx on t1;

create index idx on t1 (lower(s));


select /*+ recompile */ * from t1 where lower(s) > 'ccc';


select /*+ recompile */ * from t1 where lower(s) = 'ccc';


select /*+ recompile */ * from t1 where lower(s) < 'ddd' and lower(s) > 'bbb';


select /*+ recompile */ * from t1 where s > 'ccc' order by 1,2,3,4,5;

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, d1 double, d2 double, s varchar(255));

create index idx on t1 (i2, lower(s));

insert into t1 values (1,1,1,1,'AAA');
insert into t1 values (2,2,2,2,'BBB');
insert into t1 values (3,3,3,3,'CCC');
insert into t1 values (4,3,4,4,'DDD');
insert into t1 values (5,3,4,5,'EEE');
insert into t1 values (6,3,6,6,'FFF');
insert into t1 values (7,3,7,7,'GGG');
insert into t1 values (8,3,8,8,'HHH');
insert into t1 values (9,3,9,9,'III');


select /*+ recompile */ * from t1 where i2 = 3 and lower(s) > 'eee';


select /*+ recompile */ * from t1 where i2 = 3 and lower(s) > 'eee' and lower(s) < 'hhh';


select /*+ recompile */ * from t1 where i2 > 2 and s > 'ccc';


select /*+ recompile */ * from t1 where s > 'ccc' order by 1,2,3,4,5;

drop index idx on t1;

create index idx on t1 (i2, lower(s));


select /*+ recompile */ * from t1 where i2 = 3 and lower(s) > 'eee';


select /*+ recompile */ * from t1 where i2 = 3 and lower(s) > 'eee' and lower(s) < 'hhh';


select /*+ recompile */ * from t1 where i2 > 2 and s > 'ccc';


select /*+ recompile */ * from t1 where s > 'ccc' order by 1,2,3,4,5;


drop index idx on t1;

drop table t1;

