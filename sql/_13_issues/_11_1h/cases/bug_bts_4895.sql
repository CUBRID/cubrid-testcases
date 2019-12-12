--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table t (i int auto_increment primary key, n varchar(20));
insert into t(n) values ('abcdef'), ('abcdef'), ('abcdef'), ('abcdef'), ('abcdef');
select /*+ recompile */ count(*) from t where i = 3 and n = 'abcdef';
create index i_t_n on t (n(3));
select /*+ recompile */ count(*) from t where i = 3 and n = 'abcdef';
select /*+ recompile */ count(*) from t where n = 'abcdef';
drop table t;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;

