create table t1(a int, b int, c int, d int);
insert into t1 (a,b,c,d) select rownum%2, rownum%100, rownum, rownum from db_class x1, db_class x2, db_class x3, db_class x4 limit 100000;
insert into t1 values (null, null, null, null);
select distinct a from t1 order by 1;

create index idx_t1_abc on t1(a,b,c);
select distinct a from t1 order by 1;

--@queryplan
select /*+ recompile */ distinct a from t1 order by 1;

drop table t1;

