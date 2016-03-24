--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (i int, d double);
--Test
create index idx on t1 (sqrt(d));
--Test
create index idx2 on t1 (i) where i > 15;

insert into t1 values (4,25), (16,256), (20,400);
--Test
SHOW INDEXES FROM t1;
--Test
alter table t1 change column d newd double;

SHOW INDEXES FROM t1;
--Test
alter table t1 change column i newi int;

SHOW INDEXES FROM t1;
--Test
select /*+ recompile */ * from t1 where sqrt(newd) > 5;
--Test
select /*+ recompile */ * from t1 where newi < 20 using index idx2(+);

insert into t1 values (30, 900);
--Test
select /*+ recompile */ * from t1 where sqrt(newd) > 5;
--Test
select /*+ recompile */ * from t1 where newi < 20 using index idx2(+);

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
