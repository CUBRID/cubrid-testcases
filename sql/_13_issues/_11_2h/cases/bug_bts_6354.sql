--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int primary key not null, a int, b int, c int);
insert into t1 values (1,1,1,1), (2,2,2,2);
create index i_a on t1(a);

--below statement should execute successfully. But in fact, it's fail in CUBRID. It's good in MySQL
select /*+ recompile USE_NL */ ta.*, tb.* from t1 ta use index (i_a) left join t1 tb use index (i_a) on ta.a=tb.a where ta.a>0;

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
