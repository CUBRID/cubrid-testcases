--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b varchar(10) not null, c char(10) not null);

insert into t values (1, 'AA', 'AA1');
insert into t values (2, 'AA', 'AA2');
insert into t values (3, 'AC3', 'AC');
insert into t values (4, 'AC4', 'AC');
insert into t values (4, 'BB', 'BB');

create index i_t_cba on t(c,b,a);
create index i_t_bc on t(b,c);

select /*+ recompile */ * from t where a=1 and b='AA' order by a,b,c;

select /*+ recompile */ * from t where a=1 and b='AA' order by a,c;

select /*+ recompile */ * from t where a=1 and b='AA' order by c;

select /*+ recompile */ * from t where a=1 and b='AA' order by b,c;

select /*+ recompile */ * from t where a=1 and b='AA' order by c,b;

select /*+ recompile */ * from t where a=1 and b='AA' order by c,a;

select /*+ recompile */ * from t where a=1 and b='AA' order by c,a,b;

select /*+ recompile */ * from t where a=1 and b='AA' order by c,b,a;

select /*+ recompile */ * from t where a=1 and b='AA' and c='AA1' order by c,b,a;

select /*+ recompile */ * from t where a=1 and b='AA' and c='AA1';

prepare stmt from 'select /*+ recompile */ * from t where a=? and b=? order by c,b,a';
execute stmt using 1,'AA';
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ * from t where a=? and b=? order by c,b';
execute stmt using 1,'AA';
deallocate prepare stmt;



drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
