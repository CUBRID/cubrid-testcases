--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int not null, b float, c char(5), d varchar, e smallint);
create index i_t_abcd on t(a,b,c,d) with online;

insert into t values (1,1.1, 'AAAAA', 'AAAAA', 1);
insert into t values (1,1.1, 'AAAAA', 'AAAAA', 1);
insert into t values (1,1.1, 'AAAAA', 'AABBB', -1);
insert into t values (1,null, null, null, null);
insert into t values (2,2.1, 'BBBBB', 'BBBBB', 2);

prepare stmt from 'select /*+ recompile */ a,b,c,d from t group by a,b,c,d'
execute stmt
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c,d from t group by a desc,b desc,c desc,d desc'
execute stmt
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c,d from t group by a desc,b desc,c desc,d desc limit 3'
execute stmt
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c,d,count(*) from t group by a desc,b desc,c desc,d desc having count(*)>1'
execute stmt
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ a,b,c,d,count(*) from t group by a desc,b desc,c desc,d desc having count(*)>?'
execute stmt using 1
deallocate prepare stmt;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
