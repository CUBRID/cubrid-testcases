--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table t (a int, b int, c int, d int, e int);
create index i_t_abcd on t(a,b,c,d);

insert into t values (1,1,1,1,1);
insert into t values (1,1,1,1,2);
insert into t values (2,2,2,2,2);

--Skipping GROUP BY works well.
select /*+ recompile */ a,b,c,d,count(*) from t where a=1 and b=1 group  by c,d;

--Skipping GROUP BY we expected doesn't work. 
select /*+ recompile */ a,b,c,d,count(*) from t where a=1 and c=1 group  by b,d;

drop table t;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;

