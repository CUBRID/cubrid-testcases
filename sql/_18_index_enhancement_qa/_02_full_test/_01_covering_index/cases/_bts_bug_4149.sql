--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (a int,b int,c int);
insert into t1 values (1,1,1);
insert into t1 values (null, null, null);
insert into t1 values (null, 1, 1);
select a,b,c from t1;

--check: actual result is 3. It's right.
select /*+ recompile */ count(1) from t1 where a is not null or a is null;

create index i_ab on t1(a,b);
create index i_a on t1(a);

--check: actual result is 2. It's incorrect.
select /*+ recompile */ count(1) from t1 where a is not null or a is null;

drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
