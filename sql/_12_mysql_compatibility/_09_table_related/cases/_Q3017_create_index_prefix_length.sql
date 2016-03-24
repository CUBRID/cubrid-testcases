--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (a varchar(10) primary key, b varchar(10));
create index ipl_a_1 on t1(a(2));
drop table t1;

create table t1 (a varchar(10) unique, b varchar(10));
create index ipl_a_1 on t1(a(2));
drop table t1;

create table t1 (a varchar(10) not null, b varchar(10));
create index ipl_a_1 on t1(a(2));
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
create index ipl_1 on t1(a1(2));
create index ipl_2 on t1(a2(2));
create index ipl_3 on t1(a3(2));
create index ipl_4 on t1(a4(2));
create index ipl_5 on t1(a5(2));
create index ipl_6 on t1(a6(2));
create index ipl_7 on t1(a7(2));
create index ipl_8 on t1(a8(2));
create index ipl_9 on t1(a9(2));
create index ipl_10 on t1(a10(2));
create index ipl_11 on t1(a11(2));
create index ipl_12 on t1(a12(2));
create index ipl_13 on t1(a13(2));
create index ipl_14 on t1(a14(2));
create index ipl_15 on t1(a15(2));
create index ipl_16 on t1(a16(2));
create index ipl_17 on t1(a17(2));
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
create index ipl_b_1 on t1(a1(-10));
create index ipl_b_2 on t1(a2(-10));
create index ipl_b_3 on t1(a3(-10));
create index ipl_b_4 on t1(a4(-10));
create index ipl_b_5 on t1(a5(-10));
create index ipl_b_6 on t1(a6(-10));
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
create index ipl_c_1 on t1(a1(40000));
create index ipl_c_2 on t1(a2(40000));
create index ipl_c_3 on t1(a3(40000));
create index ipl_c_4 on t1(a4(40000));
create index ipl_c_5 on t1(a5(40000));
create index ipl_c_6 on t1(a6(40000));
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
create index ipl_d_1 on t1(a1(0));
create index ipl_d_2 on t1(a2(0));
create index ipl_d_3 on t1(a3(0));
create index ipl_d_4 on t1(a4(0));
create index ipl_d_5 on t1(a5(0));
create index ipl_d_6 on t1(a6(0));
drop table t1;




set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
