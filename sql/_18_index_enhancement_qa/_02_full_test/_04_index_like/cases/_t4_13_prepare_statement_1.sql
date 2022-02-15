--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a varchar(10));

create index i_t_a on t(a);

insert into t values ('1234567890');

select /*+ recompile */ a from t where a like '1234567890ABCDEF%';

prepare stmt from 'select /*+ recompile */ a from t where a like ?+''%''';
execute stmt using '1234567890ABCDEF';
deallocate prepare stmt;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
