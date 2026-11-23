--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int);
insert into t values (1),(2),(3),(4),(5);

create index i_t_a  on t (a);

select /*+ recompile */ a from t where a>0;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
