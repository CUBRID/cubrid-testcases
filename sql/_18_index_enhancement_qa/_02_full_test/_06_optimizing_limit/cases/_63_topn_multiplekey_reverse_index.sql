--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (i1 int, i2 int, i3 int);
create reverse index i_t_all on t(i1, i2, i3);
insert into t values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);
insert into t values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into t values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into t values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);

create table s (i1 int, i2 int, i3 int);
create reverse index i_s_all on s(i1, i2, i3);
insert into s values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into s values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into s values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
insert into s values (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);

set system parameters 'xasl_debug_dump=yes';

select /*+ recompile */ t.* from t where t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 limit 10;

select /*+ recompile */ t.* from t where t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 desc limit 10;

select /*+ recompile */ t.* from t where t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 desc for orderby_num()<10;

select /*+ recompile */ t.* from t where t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 for orderby_num()<10;

prepare stmt from 'select /*+ recompile */ t.*  from t where t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 desc limit ?';
execute stmt using 10;
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ t.*  from t where t.i1 in (1,3,5) and t.i2=?  using index i_t_all order by t.i3 desc limit ?';
execute stmt using 1, 10;
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ t.*  from t where t.i1 in (0,1,2) and i2=1-1  using index i_t_all order by t.i3 desc limit ?';
execute stmt using 10;
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ t.*  from t where t.i1 in (0,1,2) and i2=1-1  using index i_t_all order by t.i3 desc limit ?';
execute stmt using 10;
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ t.*  from t,s where t.i1=s.i1 and t.i1 in (1,3,5) and t.i2=1  using index i_t_all order by t.i3 desc limit ?';
execute stmt using 10;
deallocate prepare stmt;

set system parameters 'xasl_debug_dump=no';
set system parameters 'use_orderby_sort_limit=n';

drop table t;
drop table s;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

set system parameters 'use_orderby_sort_limit=y';

