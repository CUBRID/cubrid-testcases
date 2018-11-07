--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (id int primary key, a char(10), b varchar(10), c datetime);

create reverse index ri_t_a_b_c on t(a,b,c) with online;

insert into t values (1, '1', '1', DATETIME'03/18/2011');
insert into t values (2, '2', '2', DATETIME'03/18/2011');
insert into t values (0, '0', '0', DATETIME'03/17/2011');
insert into t values (3, '1', '1', DATETIME'03/19/2011');
insert into t values (4, '2', '2', DATETIME'03/19/2011');

select /*+ recompile */ a,b,c from t where a > '0';

select /*+ recompile */ b,c from t where a>'0';

select /*+ recompile */ c, count(*) from t where a>'0' group by c having count(*)>1;

select /*+ recompile */ c, count(*) from t where a>'0' group by c desc having count(*)>1;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
