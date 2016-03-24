create table t1 (id int primary key not null, a int, b int, c int);
insert into t1 values (1,1,1,1), (2,2,2,2);
create index i_a on t1(a);
create index i_ab on t1(a,b);
create index i_abc on t1(a,b,c);

--test
select /*+ recompile */ * from t1 use index (i_a) where a>0 using index all except i_a;

--test
select /*+ recompile */ * from t1 use index (i_a, i_ab) where a>0 using index all except i_ab;

--test
select /*+ recompile */ * from t1 use index (i_a) where a>0 using index all except i_abc;

--test
select /*+ recompile */ * from t1 use index (i_a) where a>0 using index none except i_abc;

--test
select /*+ recompile */ * from t1 use index (i_a, i_ab,i_abc) where a>0 using index all except i_abc,i_a;

--test
select /*+ recompile */ * from t1 use index (i_a) where a>0 using index i_ab(+);

--test
select /*+ recompile */ * from t1 use index (i_a, i_abc) where a>0 using index i_ab(+);

--test
select /*+ recompile */ * from t1 force index (i_a) where a>0 using index all except i_a;

--test
select /*+ recompile */ * from t1 force index (i_a, i_ab) where a>0 using index all except i_ab;

--test
select /*+ recompile */ * from t1 force index (i_a) where a>0 using index all except i_abc;

--test
select /*+ recompile */ * from t1 force index (i_a) where a>0 using index none except i_abc;

--test
select /*+ recompile */ * from t1 force index (i_a, i_ab,i_abc) where a>0 using index all except i_abc,i_a;

--test
select /*+ recompile */ * from t1 force index (i_a) where a>0 using index none;

--test
select /*+ recompile */ * from t1 ignore index (i_a) where a>0 using index all except i_a;

--test
select /*+ recompile */ * from t1 ignore index (i_a, i_ab) where a>0 using index all except i_ab;

--test
select /*+ recompile */ * from t1 ignore index (i_a) where a>0 using index all except i_abc;

--test
select /*+ recompile */ * from t1 ignore index (i_a) where a>0 using index none except i_abc;

--test
select /*+ recompile */ * from t1 ignore index (i_a, i_ab,i_abc) where a>0 using index all except i_abc,i_a;

--test: todo: CUBRIDSUS-6356. should use i_a or i_abc
select /*+ recompile */ * from t1 ignore index (i_ab)  where a>0 using index all except i_ab;

select /*+ recompile */ * from t1 where a>0 using index all except i_ab,i_a;

--test
select /*+ recompile */ * from t1 where a>0 using index all except i_a, i_ab;

--test
select /*+ recompile */ * from t1 where a>0 using index i_a all except i_a, i_ab, i_abc;

--test
select /*+ recompile */ * from t1 where a>0 using index i_a all except i_a, i_ab, i_abc;

drop table t1;



