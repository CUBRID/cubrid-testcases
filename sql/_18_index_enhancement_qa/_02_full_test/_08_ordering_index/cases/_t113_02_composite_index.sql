--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b int, c int, d int,e int);
create index i_t_abc on t(a,b,c);
update statistics on all classes;
select /*+ recompile */ *  from t where a>0 and b>0 order by a,b,c;

create index i_t_all on t(a,b,c,d,e);
select /*+ recompile */ *  from t where a>0 and b>0 order by a,b,c,d,e;
select /*+ recompile */ *  from t where a is not null and b>0 order by a,b,c,d,e;

select /*+ recompile */ *  from t where a is not null and b>0 order by a;

--no ordering index
select /*+ recompile */ *  from t where a is not null and b>0 using index none order by a,e;
--no ordering index
select /*+ recompile */ *  from t where a is not null and b>0 using index none order by e,a,b,c,d;
--no ordering index

select /*+ recompile */ *  from t where a is not null and b>0 order by a;

insert into t values (1,1,1,1,1);
insert into t values (2,2,2,2,2);
update statistics on all classes;

select /*+ recompile */ *  from t where a is not null and b>0 and rownum<3 order by a;

select /*+ recompile */ t.*  from t where a is not null and b>0 using index none order by a+1;

select /*+ recompile */ t.*  from t where a is not null and b>0 using index none order by a;

select /*+ recompile */ t.*  from t where a is not null and b>0 order by a for orderby_num()<2;

select /*+ recompile */ t.*  from t where a is not null and b>0 order by a limit 1;

select /*+ recompile */ t.*  from t where a is not null and b>0 and rownum=1 order by a;

select /*+ recompile */ t.*  from t where a is not null and b>0 and rownum=1 order by a;

select /*+ recompile */ t.*  from t where a is not null and b>0 and inst_num()*rownum=2 order by a;

select /*+ recompile */ t.*  from t where a is not null and b>0 order by a desc;
select /*+ recompile */ t.*  from t where a is not null and b>0 using index none order by a desc,b desc;
select /*+ recompile */ t.*  from t where a is not null and b>0 order by a desc,b asc;
select /*+ recompile */ t.*  from t where a is not null and b>0 order by a desc,b desc,c desc;
select /*+ recompile */ t.*  from t where a is not null and b>0 order by a desc,b desc,c desc,d desc;
select /*+ recompile */ t.*  from t where a is not null and b>0 order by a desc,b desc,c desc,d desc, e desc;

select /*+ recompile */ t.*  from t where a is not null and b>0 using index none order by a desc,b desc,c desc,d desc, e asc;

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
