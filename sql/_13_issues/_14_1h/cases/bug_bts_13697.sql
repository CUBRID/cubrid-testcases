create table t1 (id int primary key, a int, b int, c int);
create index i_ac on t1(a,c);
insert into t1 select rownum, rownum, rownum, rownum from db_class x1, db_class x2 limit 1000;

--@queryplan
select /*+ recompile index_ss(xxxx.t1) */ * from t1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile index_ss(t1, notexist) */ * from t1 where b<5 and c<5  limit 1;

--@queryplan
select /*+ recompile INDEX_SS */ * from t1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS() */ * from t1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(t1) */ * from t1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(xxxx) */ * from t1 where b<5 and c<5  limit 1;

--@queryplan
select /*+ recompile INDEX_SS(x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(t1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(t1,x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(x2) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS INDEX_SS(x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(t1.x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(.x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(x1.) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(,x1) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(,,x1,) */ * from t1 x1 where b<5 and c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) */ * from t1 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx where b<5 and c<5  limit 1;

--@queryplan
select /*+ recompile INDEX_SS(t1,x1) */ * from t1,t1 x1 where t1.c<5 and t1.b=x1.b and x1.c<5  limit 1;
--@queryplan
select /*+ recompile INDEX_SS(t1,x1) */ * from t1 left join t1 x1 on t1.c=x1.c and x1.c<5 and t1.c<5 where t1.c<5 limit 1;

--@queryplan
prepare stmt from 'select /*+ recompile INDEX_SS(t1,x1) */ * from t1,t1 x1 where t1.c<5 and t1.b=x1.b and x1.c<5  limit 1';
--@queryplan
execute stmt;
deallocate prepare stmt;

drop table t1;

