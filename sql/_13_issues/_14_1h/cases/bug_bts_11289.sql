drop table if exists t,mille;
create table t(i int,j int ) partition by range(i) (partition pa values less than(0),partition p0 values less than (10), partition p1 values less than (100),partition p2 values less than MAXVALUE);
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4,table({0,1,2,3,4,5,6,7,8,9}) t5;

insert into t (i,j)  select i,rownum from mille;
create index t_i_j on t(i,j); 
select /*+ recompile */ count(*) from (select * from t where j between 1 and 2) tt;
select /*+ recompile  */ count(*) from (select /*+ recompile index_ss */ * from t where j between 1 and 2) tt;
drop t,mille;


create table t(i int,j int ) partition by range(i) (partition pa values less than(0),partition p0 values less than (10), partition p1 values less than (100),partition p2 values less than MAXVALUE);

create index t_i_j on t(i,j);

set optimization level 513;

select /*+ recompile */ count(*) from (select /*+ index_ss */ * from t where j between 1 and 2) tt;
drop table if exists t;
