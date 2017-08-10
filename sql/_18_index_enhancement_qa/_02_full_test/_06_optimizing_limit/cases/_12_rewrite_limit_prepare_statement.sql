--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (id int primary key, a varchar(10));
insert into t values (1,'1');
insert into t values (2,'2');
insert into t values (3,'3');
insert into t values (4,null);

create index i_t_a on t(a);

set system parameters 'xasl_debug_dump=yes';

--support keylimit rewrite. it's good.
prepare stmt from 'select /*+ recompile */ a from t where a >'''' limit ?'
execute stmt using 2
deallocate prepare stmt;

--support keylimit rewrite. it's good.
select /*+ recompile */ a from t where a >'' limit 0,2;

--not support keylimit rewrite. We exepect support also.
prepare stmt from 'select /*+ recompile */ a from t where a >'''' limit ?,?'
execute stmt using 0,2
deallocate prepare stmt;

set system parameters 'xasl_debug_dump=no';


drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
