autocommit off;
create table t1 (id int primary key, a int, b int, c int);
create index i_abc on t1(a,b, c);
insert into t1 select rownum, rownum, rownum, rownum from db_class x1, db_class x2 limit 1000;

select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;

--@queryplan
select /*+ recompile index_ls(xxx.t1) */ distinct b from t1 where b<5 limit 1;
--@queryplan
select /*+ recompile index_ls(t1, notexist) */ distinct b from t1 where b<5 limit 1;

--@queryplan
select /*+ recompile index_ls */ distinct b from t1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS() */ distinct b from t1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(t1) */ distinct b from t1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(xxxx) */ distinct b from t1 where b<5 limit 1;

--@queryplan
select /*+ recompile INDEX_LS(x1) */  distinct b from t1 where b<5 limit 1;

--@queryplan
select /*+ recompile INDEX_LS(t1) */ distinct b from t1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(t1,x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(x2) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS INDEX_LS(x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(t1.x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(.x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(x1.) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(,x1) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(,,x1,) */ distinct b from t1 x1 where b<5 limit 1;
--@queryplan
select /*+ recompile INDEX_LS(xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) */ distinct b from t1 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx where b<5 limit 1;;

--@queryplan
select /*+ recompile INDEX_LS(t1,x1) */ distinct t1.b from t1,t1 x1 where t1.b<5 and x1.b<5 and t1.b=x1.b limit 1;
--@queryplan
select /*+ recompile INDEX_LS(t1,x1) */ distinct t1.b from t1 left join t1 x1 on t1.b=x1.b  where t1.b<5 and x1.b<5  limit 1;

--@queryplan
prepare stmt from 'select /*+ recompile INDEX_LS(t1,x1) */ distinct t1.b from t1,t1 x1 where t1.b<5 and x1.b<5  limit 1';
--@queryplan
execute stmt;
deallocate prepare stmt;

drop table t1;
autocommit on;

