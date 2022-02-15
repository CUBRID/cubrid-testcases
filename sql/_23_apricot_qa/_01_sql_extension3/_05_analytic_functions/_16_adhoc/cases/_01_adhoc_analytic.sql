drop table if exists foo;
create table foo(col1 blob, col2 varchar(10), primary key(col2)) partition by hash(col2) partitions 2;
insert into foo values(B'1011', '');
insert into foo values(B'1100', '');
insert into foo values(B'1011', 'a');
insert into foo values(B'1011', 'a ');
insert into foo values(B'1100', '001');
insert into foo values(B'1011', '\ a');
insert into foo values(B'1011', 'a  ');
insert into foo values(B'1011', 'a ');
insert into foo values(B'1011', 'a   ');
insert into foo values(B'1011', 'a b');
insert into foo values(B'1011', 'a   b');
select row_num from (select col2,row_number() over(partition by col2) row_num from foo) order by 1;
drop table foo;





drop table if exists t1;
create table t1(a varchar(10)) ;
create table t2(a String);

insert into t1 values('a');
insert into t1 values('a ');
insert into t1 values('a  ');

insert into t2 values('a');
insert into t2 values('a ');
insert into t2 values('a  ');

select row_num from (select a,row_number() over(partition by a) row_num from t1) order by 1;
select row_num from (select a,row_number() over(partition by a) row_num from t2) order by 1;
drop table t1;







drop table if exists t1;
create table t1(a varchar(40),b  varchar(30)) partition by list(a) (partition b1 values in ('a','b') );
insert into t1 select 'a','b' from db_class limit 43;
insert into t1 select '-a','b' from db_class limit 43;
insert into t1 select '+a','b' from db_class limit 43;
insert into t1 select '!a','b' from db_class limit 43;
insert into t1 select 'a','b' from db_class limit 43;
insert into t1 select '-a','b' from db_class limit 43;
insert into t1 select '+a','b' from db_class limit 43;
insert into t1 select '!a','b' from db_class limit 43;
insert into t1 select '"','b' from db_class limit 43;
insert into t1 select '&','b' from db_class limit 43;
insert into t1 select 'C&C++','b' from db_class limit 43;
select a,row_number() over(partition by b order by 1) row_num from t1  order by 1, 2;
drop table t1;







drop table if exists t1;
create table t1(a varchar(2000),b  varchar(2000));
insert into t1 select '-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a-a','+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a' from db_class limit 42;
select a,row_number() over(partition by b order by 1) row_num from t1  order by 1, 2;
drop table t1;










drop table if exists foo;
create table foo(a int, b int, c varchar(10)) ;
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'ccc');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');
select a,b from foo where rownum in (  select rownum from ( select rownum,row_number() over (partition by c order by a desc) rn  from foo ) where rn = 1 );
select a, stddev(a) over(order by a), stddev(a) over() from foo  order by 1, 2;
drop table foo;







drop table if exists t1;
create table t1 (
a int default -1, 
b INTEGER NOT NULL default -2, 
c SMALLINT NOT NULL default -3 ,
d BIGINT NOT NULL default -4,e NUMERIC ,
f FLOAT , 
g MONETARY NOT NULL default -0.0,
h date NOT NULL default sys_date ,
i time NOT NULL default unix_timestamp(),
j timestamp NOT NULL default sys_timestamp ,
k  datetime NOT NULL  default sys_datetime,
l BIT not null default B'1',
m set(int, CHAR(1) ) not null default {'1'},
n  multiset(int, CHAR(1)) not null default {'1'},
o list(int, CHAR(1))  not null default {'1'},
p char(10) not null default '-1',
q char(100) not null default '-1',
r char(500) NOT NULL default '-1',
index i_t1_b(b),index i_t1_c(c),index i_t1_d(d),index i_t1_e(e),
index i_t1_f(f),index i_t1_g(g),index i_t1_h(h),index i_t1_i(i),
index i_t1_j(j),index i_t1_k(k),index i_t1_l(l),index i_t1_p(p),
index i_t1_q(q),index i_t1_r(r),
index i_t1_bc(b,c),index i_t1_def(d,e,f),index i_t1_ghi(g,h,i),
index i_t1_jkl(j,k,l),index i_t1_nopqr(p,q,r),primary key(a,b)) partition by hash(b) partitions 3; ;   

insert into t1(a) select  rownum from db_class,db_class b limit 1000;

select a,b,row_number() over(partition by b order by 2) row_num from (select a,b from t1 order by 1,2) t1  order by 1;

select g,row_number() over(partition by g order by 1) row_num from t1  order by 1;

select l,row_number() over(partition by l ) row_num from t1  order by 1;

select ml,row_number() over(partition by m ) row_num from t1  order by 1;

select q,row_number() over(partition by q ) row_num from t1  order by 1;

select r,row_number() over(partition by r ) row_num from t1  order by 1;

select r,row_number() over(partition by b,c,d,e,f,g,h,i,j,k ) row_num from t1  order by 1;

select b,rownum from t1 where rownum in (  select rownum from ( select rownum,row_number() over (partition by c order by a desc) rn  from t1 ) where rn = 1 );

select  stddev(a) over() from t1  order by 1;

drop t1;






drop table if exists t;
create table t(a int, b int);
insert into t values(1, 2), (3, 4), (1, 5), (3, 9);
select all a,b,row_number() over(partition by a order by 2 desc) from t  order by 1;
select all a,b,row_number() over(partition by a order by b-a desc) from t  order by 1;
select all row_number() over() from t order by 1;
select row_num from (select all a,row_number() over() row_num from t) order by 1;
select all a,row_number() over(partition by a ) rowid from t  order by 1;
select all a,b,row_number() over(partition by a order by b desc) from t  order by 1;
select all a,b,row_number() over(partition by a order by b asc) from t  order by 1;
select distinct b,row_number() over(partition by a order by 1 asc) from t  order by 1;
select row_number() over(partition by a order by a asc) from t order by 1;
drop t;




drop table if exists t;
create table t(a DOUBLE);
insert into t values(1), (2), (3);
--result is incorrect
select var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11);select var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11),var_samp(1.11) from t; 

drop t;











drop table if exists foo;
create table foo(data2 string, primary key(data2));
INSERT INTO foo([data2]) VALUES ('aaa
!');
insert into foo values('aaa
 ;bbb');
 insert into foo values('aaa
 bbb');
 select data2,row_number() over(partition by data2 order by 1 asc) from foo  order by 1;
 select data2, avg(data2) over(order by data2) from foo;
 select data2, stddev(data2) over(order by data2), stddev(data2) over() from foo  order by 1;
drop table foo;








drop table if exists foo;
create table foo(a int);
insert into foo values(1);
insert into foo values(null);
select a, VAR_POP (a) over(order by a) from foo  order by 1;
select a, VAR_POP (a) over(order by a desc) from foo  order by 1;
drop table  foo;





drop table if exists foo;
create table foo(a int);
insert into foo values(10);
insert into foo values(20);
insert into foo values(30);
insert into foo values(40);
select /*+recompile */ a, var_samp(a) over(order by a) from foo  order by 1;
select a,row_number() over(partition by a),row_number() over(),row_number() over(partition by a),row_number() over() ,row_number() over(partition by a),row_number() over(partition by a) ,row_number() over(partition by a),row_number() over(partition by a) ,row_number() over(partition by a)  from foo  order by 1;
select /*+recompile */a ,row_number(),row_number() over(partition by a) row_num from foo  order by 1;
drop table  foo;









drop table if exists t2;
create table t2(i1 int, i2 int, i3 int);
insert into t2 values
(1,1,1),
(1,1,2),
(1,2,1),
(1,2,2),
(1,2,3),
(2,1,1),
(2,1,2),
(2,1,3),
(2,1,4),
(2,2,1),
(2,2,2),
(2,3,1),
(2,3,2),
(2,3,3);
select i1,i2 from (
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
union ALL
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) ) order by 1;

select i1,i2 from (
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
DIFFERENCE
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) ) order by 1;

select i1,i2   from  (
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
union ALL
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) )  t order by 1;

select i1,i2, row_number() over(order by i1 asc, i2 desc) as i3 from  (
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
union ALL
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) )  t order by 1;

select a1,i2, row_number() over(partition by i2) as i3 from  (
(select i1 as a1 ,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
union ALL
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) )  t order by 1;

select distinct a1,i2, row_number() over(partition by i2) i3  from  (
(select i1 as a1 ,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1)
union ALL
(select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2 where i1<3 and i1>1) )  t order by 1;

drop t2;



drop table if exists t1;
 create table t1 (a int auto_increment primary key, b int,c CHAR(131072),d short auto_increment(1000,1000),e int  auto_increment(1000,1000)) partition by hash(a) partitions 3;

insert into t1 select null,rownum,rownum||'                                                                                                                                                                      !!',null,null from db_class limit 10;


insert into t1 select null,rownum,rownum||'                                                                                                                                                                      !!                                                                                                               !!!',null,null from db_class limit 10;
select * from (select a, row_number() over(partition by c) row_num from t1 order by 1 limit 5,5) order by 1 ;

drop t1;
