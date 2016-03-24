--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t5(col1 int not null, col2 int not null, col3 int not null, col4 int not null, col5 int not null);
create index i_t5_123 on t5(col1,col2,col3);
insert into t5 select rownum,rownum,rownum,rownum,rownum from db_class a, db_class b, db_class c limit 100;

--The following sql is correct
select /*+ recompile */ col1,col2,col3 from t5 where col1>0;

--The following sql should use index i_t5_123
select /*+ recompile */ * from (select  col1,col2,col3  from t5) t order by 1,2,3;

drop table t5;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
