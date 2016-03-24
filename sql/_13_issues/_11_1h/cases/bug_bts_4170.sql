--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table t1(c1 int, c2 int, c3 int);
create index i_bc on t1(c2,c3);
create index i_b on t1(c2);

insert into t1 values (null, null, null);

select /*+ recompile */ c2 from t1 where c2>0;
select /*+ recompile */ c2 from t1 where c2 is not null;


drop table t1;
set  system parameters 'dont_reuse_heap_file=no';

commit;
--+ holdcas off;

