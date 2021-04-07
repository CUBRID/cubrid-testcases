--TEST: [Function Based Index] Function based index cannot be used when the IN expression contains a subquery


create table t(a char(10));
create index i1 on t(upper(a));
insert into t values('a'), ('b'), ('c');

--update statistics
update statistics on t;

--function index can be used
select /*+ recompile */ * from t where upper(a) in ('A');
--function index cannnot be used 
select /*+ recompile */ * from t where upper(a) in (select 'A' from t);

select /*+ recompile */ * from t where upper(a) in (select upper(a) from t where a < 'c') order by 1;

select /*+ recompile */ * from t where upper(a) = any(select upper(a) from t where a > 'a') order by 1;

select /*+ recompile */ * from t where upper(a) < some(select upper(a) from t where a in ('a', 'c')) order by 1;

select /*+ recompile */ * from t where upper(a) >= all(select upper(a) from t where a < 'b');


drop table t;
