--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int, b float, c char(5), d varchar, e smallint);
create index i_t_abcd on t(a,b,c,d) with online;

insert into t values (1,1.1, 'AAAAA', 'AAAAA', 1);
insert into t values (1,1.1, 'AAAAA', 'AAAAA', -1);
insert into t values (2,2.1, 'BBBBB', 'BBBBB', 2);

select /*+ recompile */ a,b,c,d from t where a>0 and b>0 group by a,b,c,d;

select /*+ recompile */ a,d from t where a>0 and b>0 group by a,b,c,d;

select /*+ recompile */ a from t where a>0 and b>0 group by a,b,c,d;

select /*+ recompile */ a,b,c,d from t where a>0 group by a,b,c,d;

select /*+ recompile */ a,b,c,d,count(*) from t where a>0 group by a,b,c,d;

select /*+ recompile */ a,b,c,d,count(*) from t where a>0 and rownum<10 group by a,b;

select /*+ recompile */ a,b,c,d,count(*) from t where a>0 group by a,b;

select /*+ recompile */ a,b,count(*) from t where a>0 using index i_t_abcd keylimit 1  group by 1,2;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd keylimit 1;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd keylimit 0,1;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd keylimit 1,1;

select /*+ recompile */ a,b,count(*) from t where a>0  group by a,b using index i_t_abcd keylimit 2;

select /*+ recompile */ a,b,count(*) from t where a>0 group by a,b order by a,b limit 1;

select /*+ recompile */ a,b,count(*) from t where a>0 and rownum<5 group by a,b;

select /*+ recompile */ a,b,count(*) from t where a>0 group by a,b;

select /*+ recompile */ a,b,count(*),max(e),min(e) from t where a>0 group by a,b;

select /*+ recompile */ a,b,count(*),max(e),min(e) from t where a>0 group by a;

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
