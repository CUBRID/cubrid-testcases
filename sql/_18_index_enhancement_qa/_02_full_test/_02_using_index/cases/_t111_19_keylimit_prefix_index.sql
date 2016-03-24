--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(a varchar(10) );
insert into t1 values ('AAA');
insert into t1 values ('BBA');
insert into t1 values ('BBB');
insert into t1 values ('CCC');
insert into t1 values ('CAC');

create index i_t1_pr on t1(a(1));

select /*+ recompile */ * from t1 where a in ('AAA','BBB') using index i_t1_pr keylimit 2;

drop table t1;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
