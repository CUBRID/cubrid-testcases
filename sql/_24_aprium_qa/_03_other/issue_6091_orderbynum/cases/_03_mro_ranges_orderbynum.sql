-- check multiple range optimization with more than one column on a sigle table
--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;
create table t (a int, b int, c int, d int, e int);

insert into t select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2,
	(select 1 union select 2) as t3,
	(select 1 union select 2) as t4,
	(select 1 union select 2 union select 3) as t5;
	
create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);

-- check order by column order and sorting direction
select /*+ recompile */ * from t
	where a in (1,3)
	order by b, c desc, d, e desc for orderby_num() < 5;
-- reversed index:
select /*+ recompile */ * from t
	where a in (1,3)
	order by b desc, c, d desc, e for orderby_num() > 5;
-- orders do not match:
select /*+ recompile */ * from t
	where a in (1,3)
	order by b,c,d,e for orderby_num() between 1 and 10;
-- columns do not match
select /*+ recompile */ * from t
	where a in (1,3)
	order by c desc, b, d, e desc for orderby_num() > 5 and orderby_num() < 5 ;
select /*+ recompile */ * from t
	where a in (1,3)
	order by b, d, e desc for orderby_num() > 5;
-- don't need to include all columns
select /*+ recompile */ * from t
	where a in (1,3)
	order by b, c desc, d limit 5;
-- first columns cannot be in order by list
select /*+ recompile */ * from t
	where a in (1,3) and d = 1
	order by a, b, c desc for orderby_num() < 5;
	
-- hint NO_MULTI_RANGE_OPT
select /*+ recompile NO_MULTI_RANGE_OPT */ * from t
	where a in (1,3)
	order by b, c desc, d, e desc for orderby_num() < 10;


-- check orderby for (or limit) clause
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc limit 5;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc limit 2, 5;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() <= 5;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() >= 5;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() between 2 and 5;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() <= 5 and orderby_num() <= 10;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() <= 5 or orderby_num() <= 10;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() <= 200;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c = 1
	order by d, e desc for orderby_num() <= 200 and orderby_num() <= 5;

-- any number of key filters are allowed if all conditions are met
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and c > 1 and d < 2 and e < 3
	order by c, d desc, e limit 5;



-- cannot have correlated subqueries that may filter results
create table x (a int);
insert into x values (1);

select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and a = (select count (*) from x where x.a = t.c)
	order by c desc, d, e desc for orderby_num() <= 10 or orderby_num() <= 5;

drop table x;

-- requires no data filter
drop index idx_a_b_cd_d_ed on t;
create index idx_a_b_cd_d on t (a, b, c desc, d);
select /*+ recompile */ * from t
	where a in (1,3) and b = 1
	order by c desc, d,e for orderby_num() <= 10 or orderby_num() <= 5;
-- data filter:
select /*+ recompile */ * from t
	where a in (1,3) and b = 1 and e = 1
	order by c desc, d for orderby_num() <= 10 or orderby_num() <= 5;

drop t;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
