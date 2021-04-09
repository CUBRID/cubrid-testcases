--+ holdcas on;

drop table if exists t1;

create table t1 (a int, b int, c int, d int);
create index i1_a on t1(a);
create index i1_ab on t1(a, b);
create index i1_abc on t1(a, b,c);

insert into t1 values (1,1,1,1), (2,2,2,2);

-- we expect ignore index i1_a, but in fact, i1_a is still adopt.
select /*+ recompile */ * from t1 ignore index (i1_a) where a>0;

select /*+ recompile */ * from t1 ignore index (i1_ab) where a>0;

select /*+ recompile */ * from t1 ignore index (i1_a) where a>0 and b>0 and c>0;

select /*+ recompile */ * from t1 ignore index (i1_abc) where a>0 and b>0 and c>0;

drop table t1;

--+ holdcas off;
commit;

