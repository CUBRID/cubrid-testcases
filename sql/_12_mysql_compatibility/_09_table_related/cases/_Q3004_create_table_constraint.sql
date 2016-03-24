--+ holdcas on;
set system parameters 'compat_mode=mysql';
create table t1(a int, b varchar(10), c date, constraint symbol primary key idx_a(a));
drop table t1;
create table t1(a int, b varchar(10), constraint symbol primary key idx_a(a), c date );
drop table t1;
create table t1(a int, constraint symbol primary key idx_a(a), b varchar(10), c date );
drop table t1;
create table t1(constraint symbol primary key idx_a(a), a int, b varchar(10), c date );
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key idx_a(a), constraint symbol unique index idx_a(b));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key idx_a(a), constraint symbol primary key idx_b(b));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key idx_a(a), constraint symbol unique index idx_b(b));
drop table t1;

create table t1(a int, b varchar(10), c date, constraint symbol primary key (a));
drop table t1;
create table t1(a int, b varchar(10), constraint symbol primary key (a), c date );
drop table t1;
create table t1(a int, constraint symbol primary key (a), b varchar(10), c date );
drop table t1;
create table t1(constraint symbol primary key (a), a int, b varchar(10), c date );
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key (a), constraint symbol unique index (b));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key (a), constraint symbol primary key (b));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key (a), constraint symbol unique index (b));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key (a,b,c), constraint symbol unique index (b,c));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint symbol unique index (a,b), constraint symbol unique index (b,a));
drop table t1;
create table t1(a int, b varchar(10), c date, constraint primary key (a,b,c), constraint unique index (a,b), constraint unique index (a,c), constraint unique index (b,c), constraint unique index (a),constraint unique index (b),constraint unique index (c));
drop table t1;

create table t1(a int auto_increment, b varchar(10), c int, d date,
	unique index a1(a),
	unique index a2(a), 
	unique index a3(a), 
	unique index a4(a), 
	unique index a5(a),
	unique index a6(a),
	unique index a7(a),
	unique index a8(a),
	unique index a9(a),
	unique index a10(a),
	unique index a11(a),
	unique index a12(a),
	unique index a13(a),
	unique index a14(a),
	unique index a15(a),
	unique index a16(a),
	unique index a17(a),
	unique index a18(a),
	unique index a19(a),
	unique index a20(a),
	unique index a21(a),
	unique index a22(a),
	unique index a23(a),
	unique index a24(a),
	unique index a25(a),
	unique index a26(a),
	unique index a27(a),
	unique index a28(a),
	unique index a29(a),
	unique index a30(a),
	unique index _a1(a),
	unique index _a2(a), 
	unique index _a3(a), 
	unique index _a4(a), 
	unique index _a5(a),
	unique index _a6(a),
	unique index _a7(a),
	unique index _a8(a),
	unique index _a9(a),
	unique index _a10(a),
	unique index _a11(a),
	unique index _a12(a),
	unique index _a13(a),
	unique index _a14(a),
	unique index _a15(a),
	unique index _a16(a),
	unique index _a17(a),
	unique index _a18(a),
	unique index _a19(a),
	unique index _a20(a),
	unique index _a21(a),
	unique index _a22(a),
	unique index _a23(a),
	unique index _a24(a),
	unique index _a25(a),
	unique index _a26(a),
	unique index _a27(a),
	unique index _a28(a),
	unique index _a29(a),
	unique index _a30(a),	
	unique key b1(b),
	unique key b2(b),
	unique key b3(b),
	unique key b4(b),
	unique key b5(b),
	unique key b6(b),
	unique key b7(b),
	unique key b8(b),
	unique key b9(b),
	unique key b10(b),
	unique key b11(b),
	unique key b12(b),
	unique key b13(b),
	unique key b14(b),
	unique key b15(b),
	unique key b16(b),
	unique key b17(b),
	unique key b18(b),
	unique key b19(b),
	unique key b20(b),
	unique key b21(b),
	unique key b22(b),
	unique key b23(b),
	unique key b24(b),
	unique key b25(b),
	unique key b26(b),
	unique key b27(b),
	unique key b28(b),
	unique key b29(b),
	unique key b30(b),
	unique key _b1(b),
	unique key _b2(b),
	unique key _b3(b),
	unique key _b4(b),
	unique key _b5(b),
	unique key _b6(b),
	unique key _b7(b),
	unique key _b8(b),
	unique key _b9(b),
	unique key _b10(b),
	unique key _b11(b),
	unique key _b12(b),
	unique key _b13(b),
	unique key _b14(b),
	unique key _b15(b),
	unique key _b16(b),
	unique key _b17(b),
	unique key _b18(b),
	unique key _b19(b),
	unique key _b20(b),
	unique key _b21(b),
	unique key _b22(b),
	unique key _b23(b),
	unique key _b24(b),
	unique key _b25(b),
	unique key _b26(b),
	unique key _b27(b),
	unique key _b28(b),
	unique key _b29(b),
	unique key _b30(b),	
	primary key pk(a)
	
); 
drop table t1;

create table t1 (a int primary key);
alter table t1 add column b int primary key;
drop table t1;

create table t1 (a int);
alter table t1 add column b int primary key;
alter table t1 drop column b;
alter table t1 add column c int primary key;
drop table t1;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
