--TEST:  [index skip scan] ISS depends on selected columns
set system parameters 'dont_reuse_heap_file = yes';

drop table if exists t1;

create table t1 (a int, b int, c int);
insert into t1 select rownum%2, rownum%1000, rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
create index i_t1 on t1 (a,b);

update statistics on all classes;
--ISS should be used.
select * from (select /*+ recompile INDEX_SS */ *	 from t1 where b=10) order by a,c limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ a	 from t1 where b=10 order by a limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ b	 from t1 where b=10 order by b limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ c	 from t1 where b=10 order by c limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ a,b	 from t1 where b=10 order by a limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ a,c	 from t1 where b=10 order by a,c limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ b,c	 from t1 where b=10 order by c limit 1;

--ISS should be used.
select /*+ recompile INDEX_SS */ a,b,c	 from t1 where b=10 order by a,c limit 1;


drop table t1;

set system parameters 'dont_reuse_heap_file = no';
