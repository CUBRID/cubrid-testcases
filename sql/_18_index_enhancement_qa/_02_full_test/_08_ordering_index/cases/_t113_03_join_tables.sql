--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b int, c int, d int,e int);

create index i_t_abc on t(a,b,c);
insert into t values (1,1,1,1,1);
insert into t values (2,2,2,2,2);
insert into t values (5,5,5,5,5);
insert into t values (null,null,null,null,null);

create table s(a int, b int, c int, d int,e int);

create index i_s_abc on s(a,b,c);
insert into s values (1,1,1,1,1);
insert into s values (2,2,2,2,2);
insert into t values (5,5,5,5,5);
insert into s values (5,5,5,5,5);
insert into s values (null,null,null,null,null);
update statistics on all classes;

select /*+ recompile */ t.*,s.* from t,s where t.a=s.a and t.a>-1  order by t.a;

select /*+ USE_IDX i_s_abc */ t.*,s.* from t,s where t.a=s.a and t.a>-1 and s.a > -1  order by s.a;

select /*+ USE_IDX i_s_abc ORDERED */ t.*,s.* from t,s where t.a=s.a and t.a>-1 and s.a > -1  order by t.a,t.b, t.c;

drop table t;
drop table s;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
