drop table if exists t1,t2;
create table t1 (a int, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b), primary key(a,b)) partition by hash(b) partitions 2; 
create table t2 (a int, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b), primary key(a,b)) partition by hash(b) partitions 3; 
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
update statistics on t1, t2;
delete t1,t2 from t1,t2 where t1.b=t2.b and rownum < 100;
delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100;
drop table t1,t2;




drop table if exists t1,t2;
create table t1 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) ;
create table t2 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) ;
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
update statistics on t1, t2;
delete t1,t2 from t1 left outer join t2 on t1.b=t2.b and rownum < 100;
drop table t1,t2;





drop table if exists t1,t2;
create table t1(a int );
create table t2(a int );
insert into t1 values(1),(2),(3);
insert into t2 values(1),(2),(3);
update statistics on t1, t2;
select * from t1,t2 where t1.a=t2.a and rownum < 100 order by 1, 2;
select * from t1 left outer join t2 on t1.a=t2.a and rownum < 2 order by 1, 2;
drop table t1,t2;






drop table if exists t1;
create table t1 (
a int primary key default -1, 
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
index i_t1_jkl(j,k,l),index i_t1_nopqr(p,q,r));   

insert into t1(a) select  rownum from db_class,db_class b limit 100;

drop table if exists t2;
create table t2 (
a int primary key default -1, 
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
index i_t1_jkl(j,k,l),index i_t1_nopqr(p,q,r));   

insert into t2(a) select  rownum from db_class,db_class b limit 100;

update statistics on t1, t2;
delete t1,t2 from t1 left outer join t2 on t1.b=t2.b where t1.b > 0;
drop t1,t2;




drop table if exists t1,t2;
create table t1 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 6; 
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 100;;
create table t2 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 6; 
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;

ALTER TABLE t1 COALESCE PARTITION 5;

update statistics on t1, t2;
update t1,t2 set t1.b=t2.a where t1.a=t2.a and rownum <  10;

update t1,t2 set t1.b=t2.a+1 where t1.a=t2.a and t2.a<1000 and t2.a>900;

update t1,t2 set t1.b=t2.a where t1.a=t2.a and rownum > 9999;

update t1,t2 set t1.b=t2.a where t1.a=t2.a and rownum !=rownum;

update t1 , t2 set t1.a=t2.a,t1.b=t2.b,t1.c=t2.c where t1.a=t2.a and rownum <  0;
drop t1,t2;






drop table if exists t1,t2;
create table t1 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f));
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;
create table t2 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) ; 
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;
INSERT INTO t1 VALUES(-1,-1, -1, -1, -1, -1)
ON DUPLICATE KEY UPDATE b=2;
drop t1,t2;






drop table if exists t1,t;
CREATE TABLE t (i int AUTO_INCREMENT,j int primary key,k int );
ALTER TABLE t AUTO_INCREMENT = 5;
insert into t select null,rownum,rownum from db_class limit 10;
CREATE TABLE t1 (i int AUTO_INCREMENT,j int primary key,k int );
ALTER TABLE t1 AUTO_INCREMENT = 2;
insert into t1 select null,rownum,rownum from db_class limit 10;
update statistics on t1, t;
update t inner join t1 on t.i=t1.i set t.i=t1.i+1 ;
delete t,t1 from t,t1 where t.i=t1.i; 
drop table t1,t;






drop table if exists t;
CREATE TABLE t (i int AUTO_INCREMENT primary key );
ALTER TABLE t AUTO_INCREMENT = 5;
ALTER TABLE t AUTO_INCREMENT = 10;
ALTER TABLE t AUTO_INCREMENT = 2147483646;
drop table t;

drop table if exists reuse_tbl,t1;
CREATE TABLE reuse_tbl (a INT PRIMARY KEY) REUSE_OID;
INSERT INTO reuse_tbl VALUES (1);
INSERT INTO reuse_tbl VALUES (2);
INSERT INTO reuse_tbl VALUES (3);
delete from reuse_tbl;





drop table if exists t1,t2,t3;
create table t1 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 10; 

insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;

create table t2 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 9; 

insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;


create table t3 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 8; 

insert into t3 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;

--select * from t1 right outer join t2 on t2.c=t1.b right outer join t3 on t3.c=t1.b ;

update statistics on t1, t2, t3;
update t1 right outer join t2 on t2.c=t1.b right outer join t3 on t3.c=t1.b set t1.b=t2.c, t2.b=t1.b,t3.b=t1.b;


 drop table if exists t1,t2,t3;
create table t1 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 16 ; 
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
create table t2 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 32 ;
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
create table t3 (a int , b int, c int, d char(10),e char(100),f char(5000),index i_t1_b(b) ,PRIMARY KEY(a,b,c,d,e,f)) partition by hash(f) partitions 64 ;
insert into t3 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2 limit 100;;
--select * from t1 right outer join t2 on t2.c=t1.b right outer join t3 on t3.c=t1.b where  rownum <2;
update statistics on t1, t2, t3;
update t1 right outer join t2 on t2.c=t1.b right outer join t3 on t3.c=t1.b set t1.b=t2.c, t2.b=t1.b,t3.b=t1.b;
ALTER TABLE t1 COALESCE PARTITION 2;
ALTER TABLE t2 COALESCE PARTITION 3;
ALTER TABLE t3 COALESCE PARTITION 1;
update t1 right outer join t2 on t2.a=t1.a right outer join t3 on t3.c=t1.c set t1.a=t2.b, t2.b=t1.b, t3.c=t1.a;
delete t1,t2,t3 from t1,t2,t3 where t1.a=t2.a and t2.a=t3.a;
drop table t1, t2, t3;


create table t1 like reuse_tbl;
insert into t1 select rownum from db_class limit 40;
insert into reuse_tbl select * from t1;
create table t2 like reuse_tbl;
insert into t2 select rownum from db_class limit 40;
update statistics on t1, t2;
delete t1,t2 from t1,reuse_tbl t2 where t1.a=t2.a;
insert into t1 select rownum from db_class limit 40;
insert into t2 select * from t1;
update statistics on t1, t2;
delete t1,t2 from t1 inner join reuse_tbl t2 on t1.a=t2.a;
drop table t1, t2;
drop table reuse_tbl;



drop table if exists md1,md2,md3,md4;
create table md1(id1 int primary key, col1 char(10));
insert into md1 values(11, 'aaa'), (22, 'bbb');
create table md2(id2 smallint unique primary key, col1 char(100) not null);
insert into md2 values(33, 'cubrid'), (22, 'aaa');
create table md3(id1 int primary key, col1 char(10));
insert into md3 values(11, 'aaa'), (22, 'bbb');
create table md4(id2 smallint unique primary key, col1 char(100) not null);
insert into md4 values(33, 'cubrid'), (22, 'aaa');
update statistics on md1,md2,md3,md4;
update md1 m1 right outer join md2 m2 on m2.id2=m1.id1 right outer join md3 m3 on m3.id1=m1.id1 right outer join md4 m4 on m4.id2=m1.id1 set m1.id1=m2.id2, m2.col1=m1.col1,m3.col1=m1.col1,m4.col1=m1.col1;
drop table  md1,md2,md3,md4;


