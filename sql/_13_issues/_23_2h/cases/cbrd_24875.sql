drop if exists t1, t2;

create table t1(col1 int, col2 int );
create table t2(col1 int, col2 int );
insert into t1 select rownum, random() from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c;
insert into t2 select * from t1;

create index idx on t1(col1, col2);
create index idx on t2(col1 desc, col2 desc);

select /*+ recompile */ min(col1), max(col1) from t1;
select /*+ recompile */ min(col1), max(col1) from t2;

drop table t1, t2;
