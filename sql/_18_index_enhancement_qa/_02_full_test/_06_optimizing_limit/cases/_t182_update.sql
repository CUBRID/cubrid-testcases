--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int, b varchar(10), c char(10), d timestamp);

create index i_t_a_b_c_d  on t(a,b,c,d);

insert into t select rownum, rownum||'', rownum||'', sys_timestamp from db_class a, db_class b, db_class c limit 10000;

set system parameters 'xasl_debug_dump=yes';

select /*+ recompile */ a,b,c from t where a>10000 and rownum=1;
select /*+ recompile */ a,b,c from t where a=10000 and rownum=2;
select /*+ recompile */ a,b,c from t where a<10000 and rownum=1;

select /*+ recompile */ a,b,c from t where a<1 and rownum=1;
select /*+ recompile */ a,b,c from t where a=1 and rownum=1;
select /*+ recompile */ a,b,c from t where a>1 and rownum=1;

update t set b = a%100||'' where a>10000 and rownum=10000;
update t set b = a%100||'' where a<=10000 and rownum=10000;

prepare  stmt from 'update /*+ recompile */ t set b = ''XX'' where a<10000 and rownum=?'
execute stmt using 5000
execute stmt using 4999
execute stmt using 5001
deallocate prepare stmt;

select /*+ recompile INDEX_SS */ count(*) from t where b='XX';

set system parameters 'xasl_debug_dump=no';

drop table t;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
