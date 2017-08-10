--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int not null, b varchar(10), c char(10));

insert into t values (1, 'AA', 'AA');
insert into t values (2, 'AB', 'AB');
insert into t values (3, 'AC', 'AC');
insert into t values (4, 'BB', 'BB');

create index i_t_ab on t(a,b);
create index i_t_a on t(a);
select /*+ recompile */ * from t order by a asc;
select /*+ recompile */ * from t order by a,b;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
