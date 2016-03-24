--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (id int primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
PREPARE stmt from 'insert into t1(id, a1,b2,c3,d4,e5,f6,g7,h8,i9,j10,k11,l12,m13,n14,o15,p16,q17) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
EXECUTE STMT USING 1, null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
EXECUTE STMT USING 2, null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
EXECUTE stmt USING 3,
'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
N'Härder',
N'Härder',
B'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
B'111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
123412435345,
3563562352412,
1341341,
1234,
123123,
3333223.01,
2341234123.3212,
2341234123.3212,
DATE '5/11/2010', 
TIME '16:08:33 pm',
TIMESTAMP '01/31/1994 8:15:00 pm'
DEALLOCATE PREPARE STMT;



PREPARE stmt from 'create table t2  as select * from t1'
EXECUTE stmt
DEALLOCATE PREPARE stmt;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
drop table t2;


create table t2 (id int) as select * from t1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
drop table t2;

create table t2 () as select * from t1;
drop table t2;

create table t2 (id int primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP) as select * from t1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
drop table t2;


create table t2 (id int primary key, a1 CHAR(1),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP) as select * from t1;
drop table t2;

create table t2 (id int, b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP) as select * from t1;
drop table t2;

create table t2 (xm char(1) default 'a') as select * from t1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17 and t2.xm = 'a';
drop table t2;


create table t2 as select * from t1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
insert into t2(id,a1,b2) values (1,null, null);
insert into t2(id,a1,b2) values (4,null, null);
drop table t2;

create table t2(id int primary key) as select * from t1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
insert into t2(id,a1,b2) values (1,null, null);
insert into t2(id,a1,b2) values (4,null, null);
drop table t2;

create table t2 as select t1.*, 1 as id from t1;
drop table t2;

create table s1 as select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
insert into s1 select * from t1;
select count(*) from s1;
create table t2(id int unique key) replace as select * from s1;
select count(*) from t2 left join t1 on
		t2.id=t1.id and 
		t2.a1=t1.a1 and 
		t2.b2=t1.b2 and 
		t2.c3=t1.c3 and 
		t2.d4=t1.d4 and 
		t2.e5=t1.e5 and 
		t2.f6=t1.f6 and 
		t2.g7=t1.g7 and 
		t2.h8=t1.h8 and 
		t2.i9=t1.i9 and 
		t2.j10=t1.j10 and 
		t2.k11=t1.k11 and 
		t2.l12=t1.l12 and 
		t2.m13=t1.m13 and 
		t2.n14=t1.n14 and 
		t2.o15=t1.o15 and 
		t2.p16=t1.p16 and 
		t2.q17=t1.q17;
drop table t2;
drop table s1;

create table s1 (a int default 10, b int not null);
insert into s1(b) values (1),(2),(3),(4);
create table t2 as select * from s1;
insert into t2 (a) values (1);
select count(*) from t2;
insert into t2 (b) values (5);
select count(*) from t2 where a=10 and b=5;
drop table t2;
drop table s1;

create table s1 (a int default 10, b int not null);
create view v1 as select * from s1;
insert into s1(b) values (1),(2),(3),(4);
create table t2 as select * from v1;
insert into t2 (a) values (1);
select count(*) from t2;
insert into t2 (b) values (5);
select count(*) from t2 where a=10 and b=5;
drop table t2;
drop table s1;
drop view v1;


create table t2 as select id as id from t1;
select count(*) from t2;
drop table t2;

create table t2 as select id as personId from t1;
select count(*) from t2;
drop table t2;

create table t2(personId int) as select id as personId from t1;
select count(*) from t2;
drop table t2;

-- not bug
create table t2 as select 1;
insert into t2 values (3), (2);
select `1` from t2 order by `1` asc;
drop table t2;

--bug
create table t2 as select 'as';
select * from t2;
drop table t2;

--bug
create table t2 as select '';
select * from t2;
drop table t2;

--bug
create table t2 as select '+';
select * from t2;
drop table t2;

--bug
--create table t2 as select '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
--select * from t2;
--drop table t2;
select 'this bug needs be confirmed manually' from db_root;

--bug
select 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' from db_root;
create table t2 as select 'table';
select * from t2;
drop table t2;

--bug

drop table if exists a; 
create table a(id int , a int);
create trigger a_tri before update on a execute insert into a values (0 , 0);
drop trigger a_tri;
drop table a;

create table t2 as select db_root.* from db_root;
select * from t2;
drop table t2;

--bug
create table s1 (a int, b varchar(100));
create table t2 as select s1.*,'*' from s1;
select * from t2;
drop table t2;
drop table s1;

drop table t1;

create table xoo(a int, b string, c datetime);
insert into xoo values (1, '1', sys_datetime);
create table yoo as select a,b,c,1,'1',b+'x' from xoo;
drop table yoo;
drop table xoo;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
