--+ holdcas on;
create table t1(c1 int, c2 int, c3 int);
create index i_23 on t1(c2,c3);
create index i_2 on t1(c2);

insert into t1 values (null, null, null);

--TEST: index i_2 is used actually
select /*+ recompile */ c2 from t1 where c2>0;
--TEST: index i_23 is used actually
select /*+ recompile */ c2 from t1 where c2 is not null;

--TEST: actual result is not correct.
select /*+ recompile */ c2 from t1 where c2 is null;

insert into t1 values (1, 1, 1);
--TEST: compare below three sql
select /*+ recompile */ c2 from t1 where c2 is not null using index none;
select /*+ recompile */ c2 from t1 where c2 is not null using index i_2;
select /*+ recompile */ c2 from t1 where c2 is not null using index i_23;

drop table t1;

commit;
--+ holdcas off;
