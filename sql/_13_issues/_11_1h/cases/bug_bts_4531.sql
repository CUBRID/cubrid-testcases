drop table if exists t1;
create table t1 (col1 integer);
insert into t1 values(1);
insert into t1 values(2);
create index idx_t1 on t1 (col1);
select /*+ recompile */ col1 from t1 where col1 < 2.3;
select /*+ recompile */ col1 from t1 where col1 < 2.5;
drop table t1;

create table t1 (col1 short);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
create index idx_t1 on t1 (col1);
select  col1 from t1 where col1 < 2.3; 
select  col1 from t1 where col1 < 2.5; 
drop table t1;

create table t1 (col1 int);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
create index idx_t1 on t1 (col1);
select  col1 from t1 where col1 < 2.3; 
select  col1 from t1 where col1 < 2.5; 
drop table t1;

create table t1 (col1 bigint);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
create index idx_t1 on t1 (col1);
select col1 from t1 where col1 < 2.3;  
select col1 from t1 where col1 < 2.5; 
drop table t1;

create table t1 (col1 float);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
create index idx_t1 on t1 (col1);
select col1 from t1 where col1 < 2.3; 
select col1 from t1 where col1 < 2.5; 
drop table t1;

create table t1 (col1 double);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
create index idx_t1 on t1 (col1);
select col1 from t1 where col1 < 2.3; 
select col1 from t1 where col1 < 2.5; 
drop table t1;
