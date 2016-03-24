create table t1 (a int, b int, c int);
insert into t1 select rownum mod 10, rownum mod 1000, rownum from db_class x1, db_class x2, db_class x3 limit 10000;
create index idx_ab on t1(a,b);
update statistics on t1;

--@queryplan
select /*+ recompile index_ls */ a from t1 group by a asc;

--@queryplan
select /*+ recompile index_ls */ a from t1 group by a desc;

drop table t1;

