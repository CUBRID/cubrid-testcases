-- check table joins for multiple range optimization
--+ holdcas on;


drop table if exists t,s,u;

create table t (a smallint, b bigint, c bigint, d smallint, e decimal(10,1)) partition by hash(c) partitions 10;

insert into t select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2,
	(select 1 union select 2) as t3,
	(select 1 union select 2) as t4,
	(select 1 union select 2 union select 3) as t5;
	
create index idx_a_b_cd_d on t (a, b, c desc, d) ;

create table s (a bigint, b bigint);

insert into s select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2;
	
create table u (a bigint, b bigint);

insert into u values (1,1),(1,3),(3,1),(3,3);

create index idx_u_a on u(a);

update statistics on all classes;
	
select /*+ recompile ordered */ * from s join t
	on s.a = t.a and s.b = t.b
	where t.a in (1,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d for orderby_num() <= 10 or orderby_num() >= 5;

	
select /*+ recompile ordered */ * from s join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d for orderby_num() <= 10 ;
	
select /*+ recompile ordered */ * from s  left join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d for orderby_num() between 5 and 105;
select /*+ recompile ordered USE_MERGE */ * from s  right join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d for orderby_num() between 10 and 50;


select /*+ recompile ordered */ * from s  inner join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d for orderby_num() between 10 and 5;


select /*+ recompile ordered */ * from t join s
	on s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d for orderby_num() between 5 and 6;
select /*+ recompile ordered */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d for orderby_num() between 5 and 50;
select /*+ recompile ordered */ * from t join s
	on s.a = t.b and s.b = t.c
	where t.a in (1,3) and t.b = 1
	order by t.a, t.b, t.c desc, t.d, t.e, s.a, s.b for orderby_num() between 5 and 500;

select /*+ recompile ordered */ * from t join s
	on s.a = t.e
	where t.a in (1,3) and t.b = 1
	order by t.c, t.d desc limit 10;

-- hint NO_MULTI_RANGE_OPT
select /*+ recompile */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d for orderby_num() between 5 and 5;
select /*+ recompile NO_MULTI_RANGE_OPT */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, d for orderby_num() between 5 and 5;
	

select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.b = s.b and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d for orderby_num() <=10;
	

select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d for orderby_num() <=00;

select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.d = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d for orderby_num() <=100;


select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.e = s.a and t.b = u.a and s.b= u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d for orderby_num() <=10;

drop s,t,u;

commit;
--+ holdcas off;
