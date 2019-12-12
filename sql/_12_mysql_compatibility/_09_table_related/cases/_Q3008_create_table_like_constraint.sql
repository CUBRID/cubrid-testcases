--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int auto_increment);
create table t2 like t1;
select * from t2;
drop table t2;
drop table t1;

create table t1(a int primary key);
create table t2 like t1;
insert into t1 values (1);
insert into t1 values (1);
insert into t2 values (1);
insert into t2 values (1);
select * from t2;
drop table t2;
drop table t1;

create table tb_group (group_id int primary key, group_name varchar(100));
create table tb_emp (emp_id int primary key, emp_name varchar(100) );
alter table tb_emp add column group_id int null foreign key references tb_group(group_id) ON UPDATE SET NULL ON DELETE SET NULL;
insert into tb_group values (1, 'g1');
insert into tb_group values (2, 'g2');
insert into tb_emp values (1, 'e1', 1);
insert into tb_emp values (2, 'e2', 2);
create table tb_group_new like tb_group;
create table tb_emp_new like tb_emp;
insert into tb_group_new values (3, 'g3');
insert into tb_group_new values (4, 'g4');
insert into tb_emp_new values (3, 'e3', 1);
insert into tb_emp_new values (4, 'e4', 2);
insert into tb_emp_new values (5, 'e5', 3);
insert into tb_emp_new values (6, 'e6', 4);
select * from tb_group order by 1;
select * from tb_emp order by 1;
select * from tb_group_new order by 1;
select * from tb_emp_new order by 1;
drop table tb_emp_new;
drop table tb_group_new;
drop table tb_emp;
drop table tb_group;


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
PREPARE stmt from 'create table t2 like t1'
EXECUTE stmt
DEALLOCATE PREPARE stmt;
PREPARE stmt from 'insert into t2  select * from t1'
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
drop table t1;
drop table t2;

create table t1(
	id int primary key,
	a1 CHAR(2000) unique key,
	a2 VARCHAR(2000) unique key,
	a3 NCHAR(2000) unique key,
	a4 NCHAR VARYING(2000) unique key,
	a5 BIT(2000) unique key,
	a6 BIT VARYING(2000) unique key,
	a7 NUMERIC unique key,
	a8 DECIMAL unique key,
	a9 INTEGER unique key,
	a10 SMALLINT unique key,
	a11 MONETARY unique key,
	a12 FLOAT unique key,
	a13 REAL unique key,
	a14 DOUBLE PRECISION unique key,
	a15 DATE unique key,
	a16 TIME unique key,
	a17 TIMESTAMP unique key	
);

create table t2 like t1;
insert into t2(id) values (1),(1);
insert into t2(id,a1) values (1, 'a'),(2, 'a');
insert into t2(id,a2) values (3, 'a'),(4, 'a');
insert into t2(id,a3) values (5, N'Härder'),(6, N'Härder');
insert into t2(id,a4) values (7, N'Härder'),(8, N'Härder');
insert into t2(id,a5) values (9, B'0'),(10, B'0');
insert into t2(id,a6) values (11, B'0'),(12, B'0');
insert into t2(id,a7) values (13, 1),(14, 1);
insert into t2(id,a8) values (15, 1),(16, 1);
insert into t2(id,a9) values (17, 1),(18, 1);
insert into t2(id,a10) values (19, 1),(20, 1);
insert into t2(id,a11) values (21, 1),(22, 1);
insert into t2(id,a12) values (23, 1.1),(24, 1.1);
insert into t2(id,a13) values (25, 1.1),(26, 1.1);
insert into t2(id,a14) values (27, 1.11),(28, 1.11);
insert into t2(id,a15) values (29, DATE '5/11/2010'),(30, DATE '5/11/2010');
insert into t2(id,a16) values (31, TIME '16:08:33 pm'),(32, TIME '16:08:33 pm');
insert into t2(id,a17) values (33, TIMESTAMP '01/31/1994 8:15:00 pm'),(34, TIMESTAMP '01/31/1994 8:15:00 pm');
select * from t2;
drop table t1;
drop table t2;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
