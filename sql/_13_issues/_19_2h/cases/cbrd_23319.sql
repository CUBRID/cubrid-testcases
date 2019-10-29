drop table if exists t1;

create table t1(a char(1200), b nchar(1200), c TIMESTAMP);
insert into t1 values ('test', N'abc', now());

create index i1 on t1(a,b,c) with online parallel 8;

drop table if exists t1;

