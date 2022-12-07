--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (i int, d double);
--Test
create index idx on t1 (sqrt(d));
--Test
create index idx2 on t1 (i) where i > 15;

insert into t1 values (4,25), (16,256), (20,400);
update statistics on t1;
--Test
SHOW INDEXES FROM t1;

alter index idx on t1 rebuild;
--Test
update statistics on t1;
SHOW INDEXES FROM t1;

alter index idx2 on t1 rebuild;
--Test
update statistics on t1;
SHOW INDEXES FROM t1;
--Test
select /*+ recompile */ * from t1 where sqrt(d) > 5;
--Test
select /*+ recompile */ * from t1 where i < 20 using index idx2(+);

insert into t1 values (30, 900);
--Test
select /*+ recompile */ * from t1 where sqrt(d) > 5;
--Test
select /*+ recompile */ * from t1 where i < 20 using index idx2(+);
--Test
alter index idx on t1 rebuild;

update statistics on t1;
SHOW INDEXES FROM t1;
--Test
alter index idx2 on t1 rebuild;

update statistics on t1;
SHOW INDEXES FROM t1;

insert into t1 values (40, 5);
--Test
select /*+ recompile */ * from t1 where sqrt(d) > 5;
--Test
select /*+ recompile */ * from t1 where i < 20 using index idx2(+);

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
