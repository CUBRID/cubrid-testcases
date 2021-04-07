-- bts 6091
-- check multi range optimization with various order by for and limit clause
--+ holdcas on;


drop if exists t,s;

create table t (a int, b int, c int);
create index t_a_b_cd on t(a, b, c desc);

insert into t values(1, 1, 1), (2, 2, 2), (3, 3, 3), 	(2, 1, 2), (2, 2, 1),(2, 3, 1),(3, 2, 1), (2, 3, 1), (1, 3, 1); 

-- no limit/order by for => multi range optimization cannot apply
select /*+ recompile */ * from t where a in (1,3) order by b, c desc;

-- limit
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 5;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 2, 3;

-- order by for
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() <= 5;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() > 2 and orderby_num() <= 5;
-- OR operator is not accepted
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() < 5 or orderby_num() < 7;
-- upper limit for orderby_num() must exist and must be less than multi_range_optimization_limit parameter
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() > 2;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() < 200;


-- check joins
create table s (x int, y int);
insert into s values
	(1, 1), (2, 2), (3, 3);

-- no limit
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc;
-- limit
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc limit 5;
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc limit 2, 3;
-- order by for
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5;
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5 and orderby_num() > 2;

drop t,s;

commit;
--+ holdcas off;
