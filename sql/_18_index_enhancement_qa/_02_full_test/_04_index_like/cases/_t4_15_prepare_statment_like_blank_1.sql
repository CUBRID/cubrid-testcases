--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a varchar(10));
--below value is necessary.
insert into t values ('');

insert into t values (' ');

--no index scan
--result is good
select /*+ recompile */ a from t where a like ' ';
--result is good
prepare stmt from 'select /*+ recompile */ a from t where a like ?';
execute stmt using ' ';
deallocate prepare stmt;

--covering index
create index i_t_a on t(a);

--result is good
select /*+ recompile */ a from t where a like ' ';
--result is not correct
prepare stmt from 'select /*+ recompile */ a from t where a like ?';
execute stmt using ' ';
deallocate prepare stmt;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
