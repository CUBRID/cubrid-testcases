--+ holdcas on;
set system parameters 'compat_mode=mysql';

--case s001
PREPARE stmt from 'create table s1 (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP)'
EXECUTE stmt
DEALLOCATE PREPARE stmt;
PREPARE stmt from 'insert into s1(a1,b2,c3,d4,e5,f6,g7,h8,i9,j10,k11,l12,m13,n14,o15,p16,q17) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
EXECUTE stmt USING null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
EXECUTE stmt USING null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
EXECUTE stmt USING 
	'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
	'qwertyuiop[]asdfghjkl\\''zxcvbnm,./`1234567890-=\\~!@#$%^&*()_+|QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?		two tab',
	N'H?rder',
	N'H?rder',
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
DEALLOCATE PREPARE stmt;
PREPARE stmt from 'update s1 set a1=''a1'' where a1 is null'
EXECUTE stmt
DEALLOCATE PREPARE stmt;

--case s002
create table s2(id int auto_increment primary key, a int);
insert into s2(a) values (1), (2), (3);
insert into s2(a) values (4), (5), (6);
insert into s2(id, a) values (null, 7), (null, 8);
insert into s2(id, a) values (100, 100);
delete from s2 where id >= 100;
insert into s2 values (null, 9);

--case s003
create table s3(id int primary key, a int, constraint unique key u_a(a));
insert into s3 values (1,1), (2,2), (3,3);

--case s004
create table s4_group (group_id int primary key, group_name varchar(100));
create table s4_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references s4_group(group_id) 
);
insert into s4_group values (1, 'group 1');
insert into s4_group values (2, 'group 2');
insert into s4_emp values (1, 'emp 1', 1);
insert into s4_emp values (2, 'emp 2', 2);

--case s005
create table s5(id int primary key, a int not null default -1, b varchar(200) null default 'OK');
insert into s5(id) values (1),(2),(3);

--case s006
create table s6 (id int primary key);
insert into s6 values (1),(2),(3);

--case s007
create table s7(id int primary key, a int unique key, b varchar(1) unique);
insert into s7 values (1, 1, 'a'),(2, 2, 'b'),(3, 3, 'c');

--case s008
create table s8(id int primary key, a int, constraint unique key (a desc));
insert into s8 values (1, 1),(2, 2),(3, 3);

--case s009
create table s9(id int primary key, a int, constraint unique key (a asc));
insert into s9 values (1, 1),(2, 2),(3, 3);

--case s010
create table s10(id int primary key, a int, index i_a(a));
insert into s10(id) values (1),(2),(3);

--case s011
create table s11_group (group_id int primary key, group_name varchar(100));
create table s11_emp (emp_id int primary key, emp_name varchar(100) );
alter table s11_emp add column group_id int null foreign key references s11_group(group_id) ON UPDATE SET NULL ON DELETE SET NULL;
insert into s11_group values (1, 'g1');
insert into s11_group values (2, 'g2');
insert into s11_group values (3, 'g3');
insert into s11_emp values (1, 'e1', 1);
insert into s11_emp values (2, 'e2', 1);
insert into s11_emp values (3, 'e3', 1);
insert into s11_emp values (4, 'e4', 2);
insert into s11_emp values (5, 'e5', 2);
insert into s11_emp values (6, 'e6', 2);
insert into s11_emp values (7, 'e4', 3);
insert into s11_emp values (8, 'e5', 3);
insert into s11_emp values (9, 'e6', 3);
update s11_group set group_id=-2 where group_id=2;
delete from s11_group where group_id=3;

--case s012
create table s12 (id int primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
create table s12_new like s12;
insert into s12_new(id) values (1), (2), (3);


--case s013
create table s13 (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
insert into s13 values (),(),();
create table s13_new as select * from s13;

--case s014
create table s14 (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
insert into s14 values (),(),();
rename table s14 to s14_new;

--case s015
create table s15_a (id int primary key, a int);
create table s15_b (id int primary key, a int);
rename table s15_a to s15_a_new, s15_b to s15_b_new;
 
--case s016
create table s16 (id int primary key, age int, name varchar(80), phone varchar(20));
alter table s16 add column mail_a varchar(100) after name;
alter table s16 add column mail_b varchar(100) first;
insert into s16 values ('test@domainname.com', 1, 30, 'Jack', 'test@domainname1.com', '1234567890');

--case s017
create table s17(id int primary key, gender int default 0, name varchar(80));
alter table s17 alter column gender set default 20;
insert into s17(id, name) values (1, 'Jack');

--case s018
create table s18(id int auto_increment primary key , age int, name varchar(80), phone varchar(20));
alter table s18 add column page_cnt int after name, add column mail varchar(100) first;
insert into s18 (id) values (),(),();

--case s019
create table s19 (id int primary key, a varchar(200));
insert into s19(id) values (1),(2),(3);
alter table s19 rename to s19_new; 

--case s020
create table s20(id int auto_increment primary key, age int, name varchar(80), phone varchar(20));
alter table s20 add column (page_cnt int after name, mail varchar(100) first);
insert into s20 (id) values (),(),();

--case s021
create table s21_group (group_id int primary key, group_name varchar(100));
create table s21_emp (emp_id int primary key, emp_name varchar(100), group_id int,
	foreign key(group_id) references s21_group(group_id) 
);
alter table s21_emp drop foreign key fk_s21_emp_group_id;
insert into s21_emp values (1, 'emp 1', 1);

--case s022
create table s22 (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
create or replace view sv22 as select * from s22;
insert into s22(id) values (),(),();

--case s023
create table s23_a (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
create table s23_b (id int auto_increment primary key, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP);
create view sv23 as select * from s23_a;
alter view sv23 as select * from s23_b;
insert into s23_b values (),(),();

--case s024
create table s24 (id int primary key, a varchar(100));
insert into s24 values (1, '111111');
insert into s24 values (2, '222222');
create index idx_a_p2 on s24(a(2));

--case s025
create table s25_a(id int primary key, a int);
create table s25_b(id int primary key, a_old int, a_new int);
create trigger s25_a_tri before update on s25_a execute insert into s25_b values (old.id, old.a, new.a);
insert into s25_a values (1, 1);
insert into s25_a values (2, 2);
update s25_a set a=10 where id=1;
update s25_a set a=20 where id=2;

--case s026
create table s26(id int auto_increment primary key);
insert into s26 values (),(),(),(),(),(),(),(),(),();
delete from s26 limit 5;

--case s027
create table s27(id int  auto_increment primary key );
insert into s27 values (),(),(),(),(),(),(),(),(),();
truncate table s27;

--case s028
create table s28(id int auto_increment primary key , a int default 10);
insert into s28 default values;
insert into s28 default values;
insert into s28 set a=20;
insert into s28 set a=default;

--case s029
create table s29(id int primary key, a varchar(16));
insert into s29 values (1,'A'),(2,'B');
insert into s29 values (1,'C') on duplicate key update a='C';

--case s030
create table s30(id int primary key, a varchar(16) unique key, b varchar(16));
insert into s30 values (1,'A', null),(2,'B', null);
insert into s30 values (3,'A', null) on duplicate key update b='Y';

--case s031
create table s31(id int primary key, a varchar(16) default 'X');
insert into s31 values (1,'A'),(2,'B');
replace into s31 values (1,'C');
replace into s31 set id=2, a=default;

--case s032
create table s32(id int primary key, a varchar(16) unique key, b varchar(16));
insert into s32 values (1,'A', null),(2,'B', null);
replace into s32 values (3,'A', 'X');
replace into s32 set id=4, a='B', b='X';

--case s033
create table s33(id int auto_increment primary key , a varchar(10), b int default -99);
insert into s33(id) values (),(),(),(),(),(),(),(),(),();
update s33 set a='X', b=default limit 5;

--case s034
create table s34 (id int auto_increment primary key , a varchar(100));
insert into s34(a) select concat('abc', 'def'); 

--case s035
create table s35(id int auto_increment primary key , a int, b varchar(100));
insert into s35(a,b) values (1, 'Y'); 
insert into s35(a,b) values (1, 'N'); 
insert into s35(a,b) values (1, 'Y'); 
insert into s35(a,b) values (1, 'N'); 
insert into s35(a,b) values (2, 'Y'); 
insert into s35(a,b) values (2, 'Y'); 
insert into s35(a,b) values (2, 'Y'); 
insert into s35(a,b) values (2, 'Y');

--case t001
--none

--case t002
create table t2(id int primary key,parentid int default 0, text varchar(32), vname VARCHAR(16) default 'haha');
insert into t2(id,text) values(1,default(vname));
insert into t2(id,parentid) values(2,default(parentid)+1000);


--case s001
select * from s1 order by id asc;

--case s002
select * from s2 order by a asc;

--case s003
select * from s3 order by id asc;

--case s004
select * from s4_group order by group_id asc;
select * from s4_emp order by emp_id asc;

--case s005
select * from s5 order by id asc;

--case s006
select * from s6 order by id asc;

--case s007
select * from s7 order by id asc;

--case s008
select * from s8 order by id asc;

--case s009
select * from s9 order by id asc;

--case s010
select * from s10 order by id asc;

--case s011
select * from s11_group order by group_id asc;
select * from s11_emp order by emp_id asc;

--case s012
select * from s12_new order by id asc;

--case s013
select * from s13 order by id asc;
select * from s13_new order by id asc;

--case s014
select * from s14_new order by id asc;

--case s015
select * from s15_a_new order by id asc;
select * from s15_b_new order by id asc;

--case s016
select * from s16 order by id asc;

--case s017
select * from s17 order by id asc;

--case s018
select * from s18 order by id asc;

--case s019
select * from s19_new order by id asc;

--case s020
select * from s20 order by id asc;

--case s021
select * from s21_emp order by emp_id asc;

--case s022
select * from sv22 order by id asc;

--case s023
select * from sv23 order by id asc;

--case s024
select * from s24 order by id asc;

--case s025
select * from s25_a order by id asc;
select * from s25_b order by id asc;

--case s026
select count(*) from s26;
 
--case s027
select * from s27 order by id asc;

--case s028
select * from s28 order by id asc;

--case s029
select * from s29 order by id asc;

--case s030
select * from s30 order by id asc;

--case s031
select * from s31 order by id asc;

--case s032
select * from s32 order by id asc;

--case s033
select count(*) from s33 where a='X';

--case s034
select * from s34 order by id asc;

--case s035
select concat(id, ',', a, ',', b) as full_name from s35 order by id asc;
select a, count(*) from s35 group by a having a<2;
select a, count(*) from s35 group by a desc;
select a, count(*) from s35 group by a asc;
select a, count(*) from s35 group by a asc with rollup;
select a a_x, count(*) as a_x from s35 group by a asc with rollup;
select a, count(*) from s35 group by a desc limit 1;
select DISTINCTROW a from s35 group by a order by a desc;

--case t002
select * from t2 order by id asc;


drop table s1;
drop table s2;
drop table s3;
drop table s4_emp;
drop table s4_group;
drop table s5;
drop table s6;
drop table s7;
drop table s8;
drop table s9;
drop table s10;
drop table s11_emp;
drop table s11_group;
drop table s12;
drop table s12_new;
drop table s13;
drop table s13_new;
drop table s14_new;
drop table s15_a_new;
drop table s15_b_new;
drop table s16;
drop table s17;
drop table s18;
drop table s19_new;
drop table s20;
drop table s21_emp;
drop table s21_group;
drop table s22;
drop view sv22;
drop table s23_a;
drop table s23_b;
drop view sv23;
drop table s24;
drop trigger s25_a_tri;
drop table s25_a;
drop table s25_b;
drop table s26;
drop table s27;
drop table s28;
drop table s29;
drop table s30;
drop table s31;
drop table s32;
drop table s33;
drop table s34;
drop table s35;
drop table t2;


set system parameters 'compat_mode=cubrid';

commit;
--+ holdcas off;
