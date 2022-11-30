--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';

--
drop table if exists t,t1;
create table t(i int,j int ) partition by range(i) (partition pa values less than(0),partition p0 values less than (10), partition p1 values less than (100),partition p2 values less than MAXVALUE);
create table t1(i int,j int ) partition by range(i) (partition pa values less than(0),partition p0 values less than (10), partition p1 values less than (100),partition p2 values less than MAXVALUE);
update statistics on t;
update statistics on t1;

insert into t__p__p0 values(5,5);
insert into t__p__p0 values(10,10);
insert into t__p__p1 values(15,15);

insert into t1__p__p0 values(5,5);
insert into t1__p__p0 values(10,10);
insert into t1__p__p1 values(15,15);

--sequence scan
select /*+ recompile */ * from t ;

--sequence scan
select /*+ recompile */ * from t partition (p0);

create index t_i on t(i);
create index t_i_j on t(i,j); 

create index t1_i on t(i);
create index t1_i_j on t(i,j); 
update statistics on t;

--order by scan
select /*+ recompile */ * from t order by i;

--index scan,iscan
select /*+ recompile */ * from t partition (p0) where i>5;

--MRO
select /*+ recompile */ * from t partition (p0) where i in(5,6) order by j limit 5 ;

--INDEX JOIN
select /*+ recompile */ * from t partition (p0) , t1 partition (p0);

--ORDER BY skip
select /*+ recompile */ t.i ,t.j from t partition (p0),t1 partition (p0) where t.i=t1.i and t.i=5 order by t.i , t.j;

--GROUP BY skip
select /*+ recompile */ * from t partition (p0) where t.i> 4 group by i;

drop table if exists t,t1;

--

drop table if exists t,mille;
create table t(i int,j int ) partition by range(i) (partition pa values less than(0),partition p0 values less than (10), partition p1 values less than (100),partition p2 values less than MAXVALUE);
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4,table({0,1,2,3,4,5,6,7,8,9}) t5;

insert into t (i,j)  select i,rownum from mille;
create index t_i_j on t(i,j); 
update statistics on t;

--index skip scan
select /*+ recompile  */  count(*) from (select  /*+ recompile index_ss */ * from t where j between 1 and 2 using index t_i_j) tt;

drop table if exists t,mille;

--
drop table if exists t;

create table t (i numeric(10,1), j double,k date,l varchar(200),m char(200),n bigint ) partition by hash(n) partitions 10;

create index idx_t_i on t (i);

create index idx_t_j on t (j);
update statistics on t;

insert into t select rownum,rownum, TO_DATE('12/25/2008'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

insert into t select rownum,rownum, TO_DATE('12/25/2009'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10;

select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10,10;

select /*+ recompile */ i,j,count(*) from t where i is not null group by i having sum(i) > 20 limit 10,10;

select /*+ recompile */ i,j from t where i > 5 and i < 200 group by j having i > 0 limit 10,20;

select /*+ recompile */ i,j,k from t where k >=  TO_DATE('12/25/2008') group by k having k <=  TO_DATE('12/25/2008') limit 10 ;

select /*+ recompile */ i,j,k,l,m,n,count(l) from t where i > 10 and i < 110 group by l having j > 100 limit 2,10;

select /*+ recompile */ i,j,k,l,m,n from t where m > 10 and m < 110 group by m having m > 100 limit 2,10;

select /*+ recompile */ i,j,k,l,m,n,avg(n) from t where n > 10 and n < 110 group by n having n > 100 limit 2,10;

drop table t;

--

drop table if exists t,t2;

create table t(a integer, b varchar(255), c varchar(4096)) PARTITION BY RANGE(a) (

	 PARTITION p0 VALUES LESS THAN (13),

        PARTITION p1 VALUES LESS THAN (15),

        PARTITION p2 VALUES LESS THAN (20),

        PARTITION p3 VALUES LESS THAN MAXVALUE

      );


insert into t partition (p0) values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters');
insert into t partition (p1) values(13, 'xa0', 'author names'),(14, 'xa1', 'xa1');
insert into t partition (p2) values(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t partition (p0) values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters');
insert into t partition (p1) values(13, 'xa0', 'author names'),(14, 'xa1', 'xa1');
insert into t partition (p2) values(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t_a on t(a);
create index i_t_b on t(b);
create index i_t_c on t(c);
create index i_t_d on t(a,b,c);

create table t2(a bigint, b varchar(255), c varchar(4096)) PARTITION BY RANGE(a) (

	 PARTITION p0 VALUES LESS THAN (13),

        PARTITION p1 VALUES LESS THAN (15),

        PARTITION p2 VALUES LESS THAN (20),

        PARTITION p3 VALUES LESS THAN MAXVALUE

);

insert into t2 partition (p0) values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters');
insert into t2 partition (p1) values(13, 'xa0', 'author names'),(14, 'xa1', 'xa1');
insert into t2 partition (p2) values(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;


create index i_t2_a on t2(a);
create index i_t2_b on t2(b);
create index i_t2_c on t2(c);
create index i_t2_d on t2(a,b,c);
update statistics on t;
update statistics on t2;

select /*+ recompile */ t.a,t.b,t2.c from t left join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.a having t.a>15 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.a having t.a<15 and t.a>0 limit 1,3;

select /*+ recompile */distinct t.a,t.b,t2.c,count(*),avg(t.a) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*),avg(t.a) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ distinct t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 3 ;

drop table if exists t,t2;

--

drop table if exists t,t2;

create table t(a integer, b varchar(255), c varchar(4096)) PARTITION BY LIST (a) (

PARTITION event1 VALUES IN (10,11, 12 ),

PARTITION event2 VALUES IN (13, 14,15),

PARTITION event3 VALUES IN (16, 17)
);

insert into t partition (event1) values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters');
insert into t partition (event2) values(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab');
insert into t partition (event3) values(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t partition (event1) values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters');
insert into t partition (event2) values(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab');
insert into t partition (event3) values(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t_a on t(a);
create index i_t_b on t(b);
create index i_t_c on t(c);
create index i_t_d on t(a,b,c);

create table t2(a bigint, b varchar(255), c varchar(4096)); 

insert into t2 values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t2 values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t2_a on t2(a);
create index i_t2_b on t2(b);
create index i_t2_c on t2(c);
create index i_t2_d on t2(a,b,c);
update statistics on t;
update statistics on t2;

select /*+ recompile */ t.a,t.b,t2.c from t left join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.c having t.a>15 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.b having t.a<15 and t.a>0 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1000000,1000000;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 10000000000000,100000000000000;

select /*+ recompile */ distinct t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 10000000000000,100000000000000;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t left outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0  order by 1 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1000 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 order by 1 limit 1000 ;

drop table if exists t,t2;

--
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

update statistics on t;
update statistics on s;
update statistics on u;
	
select /*+ recompile ordered */ * from s join t
	on s.a = t.a and s.b = t.b
	where t.a in (1,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d limit 10;

	
select /*+ recompile ordered */ * from s join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d limit 10;

	
select /*+ recompile ordered */ * from s  left join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d limit 10;

select /*+ recompile ordered USE_MERGE */ * from s  right join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d,t.e limit 10;


select /*+ recompile ordered */ * from s  inner join t
	on s.a = t.a and s.b = t.b
	where t.a not in (0,2,3,4,5) and t.b != 1 and t.a != 2 and t.d != 2
	order by t.c desc, t.d limit 10;


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
select /*+ recompile ORDERED*/ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.a, s.a, s.b limit 10;
select /*+ recompile NO_MULTI_RANGE_OPT ORDERED */ * from t join s
	on s.a = t.a
	where t.a in (1,3) and t.b = 1
	order by t.c desc, t.a, s.a, s.b limit 10;
	

select /*+ ordered */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.b = s.b and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;
	

select /*+ ORDERED */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.b = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;

select /*+ USE_NL ORDERED */ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.a = s.a and t.d = u.a and s.b = u.b and t.a in (1,3) and t.b = 1
	order by t.c desc, t.d limit 10;


select /*+ recompile ORDERED*/ t.*, s.a as sa, s.b as sb, u.a as ua, u.b as ub from t,s,u
	where t.e = s.a and t.b = u.a and s.b= u.b and t.a in (1,3) and t.b = 1
	order by t.c desc,t.a, s.a limit 10;

drop table if exists s,t,u;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
