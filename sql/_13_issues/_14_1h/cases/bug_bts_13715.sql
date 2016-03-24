create table t1 (id int primary key, a int, b int, c int);
create index i_t1_abc on t1(a,b,c);
insert into t1 select rownum, rownum%5, rownum, rownum from db_class x1, db_class x2 limit 1000;

create table t2 (id int primary key, a int, b int, c int);
create index i_t2_abc on t2(a,b,c);
insert into t2 select * from t1;
 
create view v1 as select /*+ recompile no_index_ss */ * from t1 where b>0 order by b limit 1;
--@queryplan
select /*+ recompile index_ss */ * from v1 where b>5 order by b;
--@queryplan
select /*+ recompile index_ss */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b,t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(t2) */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss() */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(v1) */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
drop view v1;

create view v1 as select /*+ recompile index_ss */ * from t1 where b>0 order by b limit 1;
--@queryplan
select /*+ recompile no_index_ss */ * from v1 where b>5 order by v1.b;
--@queryplan
select /*+ recompile */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(t2) */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(v1) */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(t1) */ * from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
drop view v1;

create view v1 as select /*+ recompile index_ss(t1) */ t1.* from t1 where b>0 order by b limit 1;
create view v2 as select /*+ recompile index_ss(t2) */ t2.* from v1,t2 where v1.b>5 and t2.b>5 order by v1.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(t1) */ * from v2,t2 where v2.b>5 and t2.b>5 order by v2.b, t2.b limit 1;
--@queryplan
select /*+ recompile no_index_ss */ * from v2,t2 where v2.b>5 and t2.b>5  order by v2.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss() */ * from v2,t2 where v2.b>5 and t2.b>5  order by v2.b, t2.b limit 1;
--@queryplan
select /*+ recompile index_ss(t2) */ * from v2,t2 where v2.b>5 and t2.b>5 order by v2.b,t2.b limit 1;
drop view v1;
drop view v2;

drop table t1;
drop table t2;

