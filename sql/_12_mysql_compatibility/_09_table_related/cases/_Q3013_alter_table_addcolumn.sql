--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(id int primary key);
alter table t1
	add column a1 CHAR(2000) unique key first ,
	add column a2 VARCHAR(2000) unique key first,
	add column a3 NCHAR(2000) unique key first,
	add column a4 NCHAR VARYING(2000) first,
	add column a5 BIT(2000) first,
	add column a6 BIT VARYING(2000) first,
	add column a7 NUMERIC first,
	add column a8 DECIMAL first,
	add column a9 INTEGER first,
	add column a10 SMALLINT first,
	add column a11 MONETARY first,
	add column a12 FLOAT first,
	add column a13 REAL first,
	add column a14 DOUBLE PRECISION first,
	add column a15 DATE first,
	add column a16 TIME first,
	add column a17 TIMESTAMP first,
	add column a18 CHAR(2000) after id,
	add column a19 VARCHAR(2000) after a18,
	add column a20 NCHAR(2000) after a19,
	add column a21 NCHAR VARYING(2000) after a20,
	add column a22 BIT(2000) after a21,
	add column a23 BIT VARYING(2000) after a22,
	add column a24 NUMERIC after a23,
	add column a25 DECIMAL after a24,
	add column a26 INTEGER  after a25,
	add column a27 SMALLINT after a26,
	add column a28 MONETARY after a27,
	add column a29 FLOAT after a28,
	add column a30 REAL after a29,
	add column a31 DOUBLE PRECISION after a30,
	add column a32 DATE after a31,
	add column a33 TIME after a32,
	add column a34 TIMESTAMP after a33;
select * from t1;
drop table t1;


create table t1(id int primary key);
alter table t1 add column a int auto_increment unique key first;
insert into t1 values (1, null);
insert into t1 values (2, 1);
insert into t1(id) values (2);
select * from t1 order by id asc;
drop table t1;

create table t1(id int);
alter table t1 add column a int auto_increment first, 
			   drop column id,
			   add column id int primary key first,
			   add column b varchar(100) not null after a,
			   add column c varchar(100) default 'TEST' after b;
insert into t1(id, a, b, c) values (1, 1, 'b1', 'c1');
insert into t1(id, a, b, c) values (1, 1, 'b1', 'c1');
insert into t1(id, a, b, c) values (2, null, 'b2', 'c2');
insert into t1(id, b, c) values (3, 'b3', 'c3');
insert into t1 values (4, null, 'b4', 'c4');
insert into t1 values (5, null, null, 'c5');
insert into t1(id) values (6);
insert into t1(id, b) values (7, 'b7');
select * from t1 order by id asc;
drop table t1;


create table t1(id int);
insert into t1 values (1),(2),(3);
alter table t1 add column a varchar(100) not null after id;
select * from t1 order by id asc;
insert into t1 (id, a) values (4, 'b4');
insert into t1 (id, a) values (5, null);
insert into t1 (id) values (5);
select * from t1 order by id asc;
drop table t1;

create table t1(id int);
insert into t1 values (1),(2),(3);
alter table t1 add column a varchar(100) default 'TEST';
insert into t1 (id, a) values (4, null);
insert into t1 (id) values (5);
select * from t1 order by id asc;
drop table t1;

			   

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
