
--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t;
create table t (a int, b int);
create index i_t_a_b on t(a,b);
insert into t select rownum,rownum from db_class limit 10;
insert into t select rownum,rownum from db_class limit 10; 
insert into t select rownum,rownum from db_class limit 10;
SELECT * FROM t WHERE a IN (1,2,3) ORDER BY b LIMIT 2;
SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) ORDER BY b LIMIT 2;
--using MRO
SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b LIMIT 10;
--Do not using MRO
SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b LIMIT 3,5;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b LIMIT 100;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b LIMIT 99;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY a,b LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY a desc ,b LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY a desc ,b desc LIMIT 5;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b desc LIMIT 5;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b desc LIMIT 5,10;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b for ORDERBY_NUM()< 5 ;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b desc ,a desc LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE b =3 ORDER BY b desc ,a desc LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE a=1  ORDER BY b desc ,a desc LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE b=1  ORDER BY b desc ,a desc LIMIT 0;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b for ORDERBY_NUM() BETWEEN 3 AND 5;

SELECT /*+ recompile */ * FROM t WHERE a <3 ORDER BY b LIMIT 10;

SELECT /*+ recompile */ * FROM t WHERE a <> 3 ORDER BY b desc LIMIT 10;

SELECT /*+ recompile */ * FROM t WHERE a =3 ORDER BY b for ORDERBY_NUM() BETWEEN 3 AND 5;

SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) and b!=1 ORDER BY b LIMIT 2;

SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) and b in(1,2,3)  ORDER BY b LIMIT 2;

SELECT /*+ recompile */ * FROM t WHERE b IN (1,2,3) and a in(1,2,3)  ORDER BY b LIMIT 2;

SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) or a in(4,5)  ORDER BY b LIMIT 2;

SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) or b in(4,5)  ORDER BY b LIMIT 10;

SELECT /*+ recompile */ a,a+b FROM t WHERE a IN (1,2,3) or b in(4,5)  ORDER BY b LIMIT 10;

SELECT /*+ recompile */ * FROM t WHERE a IN (1,2,3) and b!=1 ORDER BY b ,a LIMIT 2;

SELECT /*+ recompile */ * FROM t WHERE  b!=1 ORDER BY b ,a LIMIT 2;

SELECT /*+ recompile */ * FROM t  WHERE  b=1 ORDER BY a desc LIMIT 5;

SELECT /*+ recompile */ * FROM t  WHERE  a=1 ORDER BY b desc LIMIT 5;

SELECT /*+ recompile */ * FROM t WHERE a <3 ORDER BY a LIMIT 2;
SELECT /*+ recompile */ * FROM t WHERE b =3 ORDER BY b LIMIT 2;

drop table t;

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
--error occurs
select /*+ recompile ordered */ * from s join t
	on s.a = t.a+1 and s.b = t.b+1
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
--error occurs
select /*+ recompile  */ * from s join t
	on s.a = t.a+1 and s.b = t.b+1
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ NO_MULTI_RANGE_OPT  */ * from s join t
	on s.a = t.a+1 and s.b = t.b+1
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

--error occurs
select /*+ NO_STATS   */ * from s join t
	on s.a = t.a+1 and s.b = t.b+1
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

select /*+ NO_STATS   */ * from s join t
	on s.a = t.a+1 and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

select /*+ USE_NL   */ * from s join t
	on s.a = t.a+1 and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ USE_IDX  idx_a_b_cd_d */ * from s join t
	on s.a = t.a+1 and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ USE_DESC_IDX */ * from s join t
	on s.a = t.a+1 and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ recompile */ * from s join t
	on s.a = t.a+1 and s.b = t.b
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ recompile */ * from(
select /*+ recompile */ * from (
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.b = u.a and s.b = u.b+1 and t.a in (1,3) and t.b = 1+1
	order by t.c desc, t.d limit 10)) limit 3;

select /*+ recompile */ * from(
select /*+ recompile */ * from (
select /*+ recompile */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10)) limit 3;

drop table if exists t,s,u;

create table t (a int, b int, c int, d int, e int) ;

insert into t select * from
	(select 1 union select 2 union select 3) as t1,
	(select 1 union select 2) as t2,
	(select 1 union select 2) as t3,
	(select 1 union select 2) as t4,
	(select 1 union select 2 union select 3) as t5;

create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_c_b_d on t (a, c, b desc, d);
create index idx_a_d_c_b on t (a, d, c desc, b);
create index idx_d_a_c_b on t (d, a, c desc,b);
create index idx_c_a_d_b on t (c, a, d desc,b);
create index idx_c_a_d_b_1 on t (c, a, d ,b);

update statistics on all classes with fullscan;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1
	order by c desc, d limit 5;

drop table if exists t,s,u;

create table t (a int, b bigint, c char(500), d char(500), e char(500));

insert into t select rownum,rownum,rownum+2,rownum,rownum+2 from db_class a,db_class b ,db_class c limit 50000;

create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_c_b_d on t (a, c, b desc, d);
create index idx_a_d_c_b on t (a, d, c desc, b);
create index idx_d_a_c_b on t (d, a, c desc,b);
create index idx_c_a_d_b on t (c, a, d desc,b);
create index idx_c_a_d_b_1 on t (c, a, d ,b);

update statistics on all classes with fullscan;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1
	order by c desc, d limit 5;

update statistics on all classes with fullscan;
select /*+ recompile */ * from t
	where a in(select rownum from db_class a,db_class b) and b = 1
	order by c desc, d limit 5;


drop table if exists t,s,u;

create table t (a int, b enum('1','2','3','4','5'), c int, d int, e int) ;

insert into t select rownum,1 ,rownum+2,rownum,rownum+2 from db_class a,db_class b ,db_class c limit 50000;

create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_c_b_d on t (a, c, b desc, d);
create index idx_a_d_c_b on t (a, d, c desc, b);
create index idx_d_a_c_b on t (d, a, c desc,b);
create index idx_c_a_d_b on t (c, a, d desc,b);
create index idx_c_a_d_b_1 on t (c, a, d ,b);

update statistics on all classes with fullscan;
select /*+ recompile */ * from t
	where a in (1,3) and b = 1
	order by c desc, d limit 5;

select /*+ recompile */ distinct * from t
	where a in (1,3) and b = 1
	order by c desc, d limit 5;

drop table if exists t,s,u;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
