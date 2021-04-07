--+ holdcas on;
create table t(a int primary key, b varchar(10), c char(10));

insert into t values (1, 'AA', 'AA');
insert into t values (2, 'AB', 'AB');
insert into t values (3, 'AC', 'AC');
insert into t values (4, 'BB', 'BB');

create index i_t_ab on t(a,b);
select /*+ recompile */ * from t order by a asc;
select /*+ recompile */ * from t order by a,b;

drop table t;
commit;
--+ holdcas off;
