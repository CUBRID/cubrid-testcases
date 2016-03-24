--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20));
create index i_t1_v on t1(v(7));
insert into t1 values (1, 'dbms qa 90');

--set optimization level 513;

select /*+ RECOMPILE */ v, char_length(v) from t1 where v like 'dbms qa%' and trim(v) = 'dbms qa 90' using index none;
select /*+ RECOMPILE */ v, char_length(v) from t1 where v like 'dbms qa%' and trim(v) = 'dbms qa 90';

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;

