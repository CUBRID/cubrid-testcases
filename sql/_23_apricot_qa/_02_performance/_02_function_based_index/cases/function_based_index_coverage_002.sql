--+ holdcas on;
create table t2 (i int, d double);

--Test
create index idx on t2 (i) where i > 15;
--Test
create index idx2 on t2 (sqrt(d));

insert into t2 values (4,25), (16,256), (20,400);
--Test
select /*+ recompile */ * from t2 where sqrt(d) > 5;
--Test
select /*+ recompile */ * from t2 where i < 20 using index idx(+);

truncate table t2;

insert into t2 values (4,25), (16,256), (20,400);
--Test
select /*+ recompile */ * from t2 where sqrt(d) > 5;
--Test
select /*+ recompile */ * from t2 where i < 20 using index idx(+);

drop table t2;

commit;
--+ holdcas off;
