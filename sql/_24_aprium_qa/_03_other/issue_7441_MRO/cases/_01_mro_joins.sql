-- check table joins for multiple range optimization

--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t,s,u;

create table t (a int, b int, c int, d int, e int);

insert into t select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2,
	(select 1 union select 2) as t3,
	(select 1 union select 2) as t4,
	(select 1 union select 2 union select 3) as t5;
	
create index idx_a_b_cd_d on t (a, b, c desc, d);

create table s (a int, b int);

insert into s select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2;
	
create table u (a int, b int);

insert into u values (1,1),(1,3),(3,1),(3,3);

create index idx_u_a on u(a);

update statistics on all classes;
	
-- when the multi range optimized scan is the innermost, it may be invalidated only by "data filtering" joins
select /*+ recompile ordered */ * from s join t
	on s.a = t.a and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
select /*+ recompile ordered */ * from s join t
	on s.b = t.c
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
select /*+ recompile ordered */ * from s join t
	on s.a = t.e
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;

-- when the multi range optimized scan is not the innermost
-- the join conditions must be on attributes that are previous to the first sorting column in index
-- and that are in eq terms
select /*+ recompile ordered */ * from t join s
	on s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;
select /*+ recompile ordered */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;
select /*+ recompile ordered */ * from t join s
	on s.a = t.b and s.b = t.c
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;
select /*+ recompile ordered */ * from t join s
	on s.a = t.e
	where t.a in (1,3) and t.b = 1
	order by t.c, t.d desc limit 10;

-- hint NO_MULTI_RANGE_OPT
select /*+ recompile */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;
select /*+ recompile NO_MULTI_RANGE_OPT */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d limit 10;
	

-- check multi range optimization for complex joins
-- multi range optimization sort plan should be "outer-most"
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.b = s.b and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
	
-- multi range optimization sort plan should be second
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
	
-- multi range optimization sort plan should be innermost
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.d = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

-- there is a join that acts as data filter... multi range optimization will not be used
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.e = s.a and t.b = u.a and s.b= u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

drop s,t,u;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
