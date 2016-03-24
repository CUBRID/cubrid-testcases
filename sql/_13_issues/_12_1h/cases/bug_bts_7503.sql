set system parameters 'dont_reuse_heap_file=yes';

create table t1 (a int, b int, c int);
insert into t1 select rownum%2, rownum,rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
create index i_t1_a_b on t1(a,b);
--you will see that ISS is used. That's good.
select /*+ recompile INDEX_SS */ * from t1 where b=1;
set @x=1;
--Below statement includes an user-defined variable. we expect ISS is used also.
select /*+ recompile INDEX_SS */ * from t1 where b=@x;
drop variable @x;
drop table t1;

set system parameters 'dont_reuse_heap_file=no';

