drop table if exists t1, t2, t3, t4;
create table t1(col1 int, col2 int );
create table t2 like t1;
create table t3 like t1;
create table t4 like t1;
insert into t1 select rownum, rownum + 10000 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d;

insert into t2 select * from t1;
insert into t3 select * from t1;
insert into t4 select * from t1;

create index idx on t1(col1, abs(col2));
create index idx on t2(col1 desc, abs(col2) desc);
create index idx on t3(abs(col1), col2);
create index idx on t4(col1, col2);

set trace on;

-- positive
select /*+ recompile */ 'p_1', min(col1), max(col1) from t1;
show trace;
select /*+ recompile */ 'p_2', min(col1), max(col1) from t2;
show trace;
select /*+ recompile */ 'p_3', to_char(min(col1)), to_char(max(col2)) from t4;
show trace;


-- negative
select /*+ recompile */ 'n_1', min(col2), max(col2) from t1;
show trace;
select /*+ recompile */ 'n_2', min(col2), max(col2) from t2;
show trace;
select /*+ recompile */ 'n_3', min(col2), max(col2) from t3;
show trace;
select /*+ recompile */ 'n_4', min(col1), max(col1) from t3;
show trace;

drop table t1, t2, t3, t4;
