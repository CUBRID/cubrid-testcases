--+ holdcas on;
set system parameters 'compat_mode=mysql';

--CUBRIDSUS-3109 
create table t1(a int primary key, b int);
insert into t1 values (1,1),(2,2),(3,3),(3,4),(4,5);
select * from t1 order by b asc;
drop table t1;

create table t1(a int auto_increment, b int);
insert t1 values ();
insert into t1 values ();
insert t1 value ();
insert into t1 value ();
insert t1 values (),();
insert into t1 values (),();
insert t1 value (),();
insert into t1 value(),();
insert t1 default values;
insert into t1 default values;
select * from t1 order by a asc;
drop table t1;

create table t1(
	a1 CHAR(2000),
	a2 VARCHAR(2000),
	a3 NCHAR(2000),
	a4 NCHAR VARYING(2000),
	a5 BIT(2000),
	a6 BIT VARYING(2000),
	a7 NUMERIC,
	a8 DECIMAL,
	a9 INTEGER ,
	a10 SMALLINT,
	a11 MONETARY,
	a12 FLOAT,
	a13 REAL,
	a14 DOUBLE PRECISION,
	a15 DATE,
	a16 TIME,
	a17 TIMESTAMP
);
PREPARE stmt from 'insert into t1 set a1=?,a2=?,a3=?,a4=?,a5=?,a6=?,a7=?,a8=?,a9=?,a10=?,a11=?,a12=?,a13=?,a14=?,a15=?,a16=?,a17=?'
EXECUTE stmt USING 
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
insert into t1 set a1=null, a2=null, a3=null, a4=null, a5=null, a6=null, a7=null, a8=null, a9=null, a10=null, a11=null, a12=null, a13=null, a14=null, a15=null, a16=null, a17=null;
select count(*) from t1 ;
drop table t1;

create table t1(a varchar(10));
insert into t1 values ('0123456789');
insert into t1 values ('0123456789a');
select * from t1 order by a asc;
drop table t1;


create table t1 (a int not null auto_increment, primary key (a), t timestamp, c char(10) default "hello", i int, order_no int);
insert into t1 values (default,"12:24:33 PM 06/24/2010",default,default,1), (default,"12:24:33 PM 06/24/2010",default,default,2), (4,0,"a",5,3),(default,"12:24:33 PM 06/24/2010",default,default,4);
select a,c,i from t1 order by order_no asc;
drop table t1;

create table t1 (a int not null auto_increment, primary key (a), t timestamp, c char(10) default "hello", i int, order_no int);
insert into t1 set a=default,t="12:24:33 PM 06/24/2010",c=default, order_no=1;
insert into t1 set a=default,t="12:24:33 PM 06/24/2010",c=default,i=default, order_no=2;
insert into t1 set a=4,t=0,c="a",i=5 , order_no=3;
insert into t1 set a=5,t=0,c="a",i=null , order_no=4;
insert into t1 set a=default,t="12:24:33 PM 06/24/2010",c=default,i=default, order_no=5;
select a,c,i from t1 order by order_no asc;
drop table t1;

create table t1 (a int, b int);
insert into t1 SET a=1, b=a+1;
insert into t1 (a,b) select 1,3;
select * from t1 order by a asc, b asc;
drop table t1;




set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
