-- check the index and plan compare when multi range optimization is eligible

--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t,s,u;

create table t (a bigint, b char(200), c varchar(2000), d double, e int);

insert into t select * from
	(select 11 union select 2 union select 3) as t1,
	(select 11 union select 2) as t2,
	(select 11 union select 2) as t3,
	(select 11 union select 2) as t4,
	(select 11 union select 2 union select 3) as t5;

create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);

create index idx_cd_d_ed on t (c desc, d, e desc);

select /*+ recompile */ * from t
	where a in (11,30,10,11) and b != 1 and b is not null
	order by c desc, d, e desc limit 5;


select /*+ recompile */ * from t
	where a in (11,30,10,11) and b != 1 and b is not null
	order by c desc, d, e desc limit 5;


select /*+ recompile */ * from t
	where a in (11,30,10,11) and b != 1 and b is not null and 1!=1
	order by c desc, d, e desc limit 5;

drop index idx_cd_d_ed on t;
drop index idx_a_b_cd_d_ed on t;

-- compare two multi range optimization (choose the shortest index)
create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);

select /*+ recompile */ * from t
	where a in (1,3) and b = 11
	order by c desc, d limit 5;

select /*+ recompile */ * from t
	where a not in (1,3) and b != 1
	order by c desc, d limit 5;

drop index idx_a_b_cd_d on t;
drop index idx_a_b_cd_d_ed on t;

-- compare multi range optimization with covering
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_b_c_d_e on t (a, b, c, d, e);

select /*+ recompile */ * from t
	where a not in (1,4,5,6,3,3) and b = 11
	order by c desc, d limit 5;

drop index idx_a_b_cd_d on t;
drop index idx_a_b_c_d_e on t;

drop t;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
