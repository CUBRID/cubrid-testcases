--TEST:  [FilteredIndex] Actual data in filtered index is not consistent with filtered constains

set system parameters 'dont_reuse_heap_file = yes';


CREATE TABLE t1 (a INT, b int, c int);
--Note: a>c condition is defined 
create index i_t1_a on t1(a) where a>c;
--insert a tuple A which meet a>c condition
insert into t1 values (99,1,1);
select /*+ recompile */ * from t1 where a>0 using index i_t1_a(+);

--Tuple A should be removed from filtered index data
update t1 set c=100;

--test: tuple A should not be selected
select /*+ recompile */ * from t1 where a>0 using index i_t1_a(+);

insert into t1 values(12, 2, 100);
insert into t1 values(12, 2, 10);

select /*+ recompile */ * from t1 where a>0 using index i_t1_a(+) order by 1, 2;

update t1 set a=111 where c=100;
update t1 set c=100 where a=12;

select /*+ recompile */ * from t1 where a>0 using index i_t1_a(+) order by 1, 2;
select /*+ recompile */ * from t1 using index i_t1_a(+) order by 1, 2;

drop table t1;

set system parameters 'dont_reuse_heap_file = no';

