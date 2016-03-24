--TEST: [Function Based Index] Function Based Index will not be used when a table has an alias name in query.
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table t1 (a varchar(10), b varchar(10));
create index i1 on t1 (upper(a));
insert into t1 values ('a', 'a'), ('b', 'b');

--test: index is used. this is good.
select /*+ recompile */ * from t1 where upper(a)='A';

--test: index is used. this is good.
select /*+ recompile */ * from t1 where upper(t1.a)='A';

--test: with table alias
select /*+ recompile */ * from t1 s1 where upper(a)='A';
select /*+ recompile */ * from t1 s1 where upper(s1.a)='A';

create table t2(a char(10), b char(10));
create index i2 on t2(lower(b));
insert into t2 values('a', 'A'), ('b', 'B'), ('c', 'C');

select /*+ recompile ordered */ * from t1, t2 where t1.a=t2.a and upper(t1.a)='B';
select /*+ recompile ordered */ * from t1 a, t2 b where a.a=b.a and upper(a.a)='B';
select /*+ recompile ordered */ * from t1 a, t2 b where a.a=b.a and lower(b.b)='a';
select /*+ recompile ordered */ * from t1 a, t2 b where a.a=b.a and lower(b.b) in ('a', 'c');
select /*+ recompile ordered */ * from t1 a, t2 b where a.a=b.a and lower(b.b) in ('a', 'c') and upper(a.a) < 'b';

select /*+ recompile */ * from t1 order by 1; 


drop table t1, t2;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
