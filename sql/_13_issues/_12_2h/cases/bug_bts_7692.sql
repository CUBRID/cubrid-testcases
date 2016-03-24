--TEST: [Function Based Index] SKIP ORDER BY is expected to used

drop table if exists t1;

create table t1 (a varchar(10), b varchar(10));
create index  i_t1_upper_a on t1 (upper(a));
insert into t1 values ('a', 'a'), ('b', 'b');

--test: it's better to use SKIP ORDER BY in query plan
select /*+ recompile */ upper(a) from t1 where upper(a)='A' using index i_t1_upper_a order by upper(a) desc;
select /*+ recompile */ upper(a) from t1 where upper(a)<'C' order by upper(a) desc;
select /*+ recompile */ upper(a) from t1 where upper(a)='A' order by upper(a);

drop table t1;
