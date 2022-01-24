--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b varchar(10), c char(10) not null);

insert into t values (1, 'AA', 'AA1');
insert into t values (2, 'AA', 'AA2');
insert into t values (3, 'AC3', 'AC');
insert into t values (4, 'AC4', 'AC');
insert into t values (4, 'BB', 'BB');

create index i_t_cba on t(c,b,a);

--should support ordering index
select /*+ recompile */ * from t where b='AA' order by c,a;

--should support ordering index
select /*+ recompile */ * from t where b='AA' order by c,a,b;

--should support ordering index
select /*+ recompile */ * from t where b='AA' order by b,c,a;

--should support ordering index
select /*+ recompile */ * from t where b='AA' order by c;

--should support ordering index
select /*+ recompile */ * from t where b='AA' order by c,b;

--should support ordering index
select /*+ recompile */ * from t where c='AC' order by b,a;

--should support ordering index
select /*+ recompile */ * from t where c='AC' order by b;

--should support ordering index
select /*+ recompile */ * from t where c='AC' order by b,c;

--should support ordering index
select /*+ recompile */ * from t where c='AC' order by b,a,c;

--should support ordering index
select /*+ recompile */ * from t where c='AC         A' order by b,a,c;

--should support ordering index
select /*+ recompile */ * from t where a=4 order by c,b;

--should support ordering index
select /*+ recompile */ * from t where a=4 order by c,a;


--should support ordering index
select /*+ recompile */ * from t where a=4 order by a;


drop table t;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
