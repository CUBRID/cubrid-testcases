--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20));
create index i_t1_v on t1(v);

insert into t1 values (1, 'dbms qa1 part');
insert into t1 values (2, 'dbms qa1 part');
insert into t1 values (3, 'dbms qa2 part');
insert into t1 values (4, 'dbms qa2 part');

--TEST
select /*+ recompile */ id,v from t1 where v not like 'dbms qa1%' order by id;
--TEST
select /*+ recompile */ id,v from t1 where not v not like 'dbms qa1%' order by id;

drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
