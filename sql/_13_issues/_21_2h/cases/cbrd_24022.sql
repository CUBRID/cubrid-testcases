drop table if exists t1;

create table t1 (col1 int);
insert into t1 values (3);
select 1 from t1 connect by level <= col1;
select /*+ recompile */ 1 from (select 3 lvl from db_root) a connect by level <= a.lvl;

drop table if exists t1;
