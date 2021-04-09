--+ holdcas on;
create table t1(a int,b int,c int);
create index i_a on t1(a);
create index i_ab on t1(a,b);
create index i_abc on t1(a,b,c);
insert into t1 select rownum, rownum,rownum from db_class x1, db_class x2,db_class x3 limit 10000;
select /*+ recompile */ count(a) from t1 where a is not null;
drop table t1;

commit;
--+ holdcas off;
