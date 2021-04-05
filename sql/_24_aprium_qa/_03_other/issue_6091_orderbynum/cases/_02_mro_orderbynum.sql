-- bts 6091
-- check multi range optimization with various order by for and limit clause
--+ holdcas on;


drop if exists t,s,u;

create table t (a bigint, b float, c varchar(1000));
create index t_a_b_cd on t(a, b, c desc);

insert into t values(1, 1, 1), (2, 2, 2), (3, 3, 3), 	(2, 1, 2), (2, 2, 1),(2, 3, 1),(3, 2, 1), (2, 3, 1), (1, 3, 1); 

-- no limit/order by for => multi range optimization cannot apply
select /*+ recompile */ * from t where a in (1,3) order by b, c desc;

-- limit
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 5;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 2, 3;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 101;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc limit 100;
select /*+ NO_STATS */ * from t where a in (1,3) order by b, c desc limit 100;
select /*+ ORDERED */ * from t where a in (1,3) order by b, c desc limit 100;
select /*+ recompile */ rownum d,rownum+10000,a from t where a in (1,3) order by d, c desc limit 100;


-- order by for
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() <= 5;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() <= 101;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for ORDERBY_NUM() BETWEEN 3 AND 5;

select /*+ recompile */ * from t where a in (1,3) order by b, c desc for ORDERBY_NUM() BETWEEN 100 AND 101;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for ORDERBY_NUM() BETWEEN -100 AND 10;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for ORDERBY_NUM() BETWEEN -100+100 AND -100+100 ;
select /*+ recompile */ * from t where a in (1,3) order by b ,c desc for ORDERBY_NUM() BETWEEN -100+100 AND -100+1000 and 10;

select /*+ recompile */ * from t where a in (1,3) order by b ,c desc for ORDERBY_NUM() BETWEEN -100+100 AND -100+1000;


select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() > 2 and orderby_num() <= 5;
-- OR operator is not accepted
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() < 5 or orderby_num() < 7  or orderby_num() < 7;
-- upper limit for orderby_num() must exist and must be less than multi_range_optimization_limit parameter
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() > 2;
select /*+ recompile */ * from t where a in (1,3) order by b, c desc for orderby_num() < 200;


-- check joins
create table s (x int, y int);
insert into s values
	(1, 1), (2, 2),  (3, 3);


create table u (x int, y int);
insert into u values
	(1, 1), (2, 2),  (3, 3);

-- no limit
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc;
-- limit
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc limit 5;

select /*+ recompile */ * from t,s
	where t.a-1 = s.x+1 and t.a in (1,3) order by t.b, t.c desc limit 5;

select /*+ recompile */ * from t,s
	where t.a-1 = s.x+1 and t.a not in (2,1) order by t.b, t.c desc for orderby_num() > 2 and orderby_num() <= 5;

select /*+ recompile */ * from t,s
	where t.a-1 = s.x+1 and t.a not in (2,1) order by t.b, t.c desc for orderby_num() > 2 or orderby_num() <= 5;

select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc limit 2, 3;

select /*+ recompile */ * from t,s
	where t.a = s.x and t.a != t.a order by t.b, t.c desc limit 2, 3;

select /*+ recompile */ * from t,s
	where t.a = s.x and t.a != t.a+t.a order by t.b, t.c desc limit 2, 3;

select /*+ recompile */ * from t,s
	where t.a = s.x and t.a != t.a+t.a order by s.x desc, t.c desc limit 2, 3;

select /*+ recompile */ * from t,s
	where t.a = s.x and t.a != t.a+t.a order by s.y +  t.c desc limit 2, 3;


select /*+ recompile */ * from t,s
	where t.a = s.x and t.a != t.a+t.a order by null,s.y+t.c desc limit 2, 3;


select /*+ recompile */ * from t left join s
	on  t.a = s.x and t.a != t.a+t.a order by s.x desc, t.c desc limit 2, 3;

select /*+ recompile */ * from t right join s
	on  t.a = s.x and t.a != t.a+t.a order by s.y desc, t.c desc limit 2, 30;

select /*+ recompile */ * from t right join s 
	on  t.a = s.x and t.a != t.a+t.a right join u
	on  t.a = u.x and t.a != t.a+t.a  order by s.y desc, t.c desc limit 2, 30;

-- order by for
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5;
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5 and orderby_num() > 2;

select * from (
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5 and orderby_num() > 2) union (select /*+ recompile */ * from t,s
	where t.a-1 = s.x+1 and t.a not in (2,1) order by t.b, t.c desc for orderby_num() > 2 and orderby_num() <= 5);

insert into t select * from (select 1,2,3 from (
select * from (
select /*+ recompile */ * from t,s
	where t.a = s.x and t.a in (1,3) order by t.b, t.c desc for orderby_num() <= 5 and orderby_num() > 2) union (select /*+ recompile */ * from t,s
	where t.a-1 = s.x+1 and t.a not in (2,1) order by t.b, t.c desc for orderby_num() > 2 and orderby_num() <= 5)));

drop t,s,u;

commit;
--+ holdcas off;
