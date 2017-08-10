--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (id int, a varchar(20));
create index i_t_all on t(id,a);

insert into t values (1, 'dbms qa1 part');
insert into t values (2, 'dbms qa2 part');
insert into t values (3, 'dbms qa2 part');
insert into t values (4, 'aaa');
insert into t values (5, 'bbb');
insert into t values (6, 'ccc');
insert into t values (7, 'AAA');
insert into t values (8, 'ABA');
insert into t values (9, 'BBC');
insert into t values (10, null);
insert into t values (null, null);

set system parameters 'xasl_debug_dump=yes';

select /*+ recompile */ id,a from t where id> 0 and rownum in (2);
select /*+ recompile */ id,a from t where id> 0 and rownum in (2,4);
select /*+ recompile */ id,a from t where id> 0 and rownum in (1,1);

select /*+ recompile */ id,a from t where id> 0 and rownum not in (2,4);
select /*+ recompile */ id,a from t where id> 0 and rownum not in (0);

set system parameters 'xasl_debug_dump=no';

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
