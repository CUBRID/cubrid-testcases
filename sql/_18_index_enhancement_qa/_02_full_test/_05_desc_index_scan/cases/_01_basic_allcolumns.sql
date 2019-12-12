--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a SHORT);
insert into tb values (1,1);
insert into tb values (2,2);
create index i_tb_a on tb(a);
insert into tb values (3,3);
insert into tb values (4,4);
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a SMALLINT);
insert into tb values (1,1);
insert into tb values (2,2);
create index i_tb_a on tb(a);
insert into tb values (3,3);
insert into tb values (4,4);
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a INT);
insert into tb values (1,1);
insert into tb values (2,2);
create index i_tb_a on tb(a);
insert into tb values (3,3);
insert into tb values (4,4);
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a INTEGER);
insert into tb values (1,1);
insert into tb values (2,2);
create index i_tb_a on tb(a);
insert into tb values (3,3);
insert into tb values (4,4);
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a BIGINT);
insert into tb values (1,-9223372036854775808);
insert into tb values (2,-9223372036854775807);
create index i_tb_a on tb(a);
insert into tb values (3,9223372036854775806);
insert into tb values (4,9223372036854775807);
--TEST:
select /*+ recompile */ * from tb where a between -9223372036854775807 and 9223372036854775807 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between -9223372036854775807 and 9223372036854775807 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a NUMERIC(14,4));
insert into tb values (1,1234567890.123);
insert into tb values (2,1234567890.1231);
create index i_tb_a on tb(a);
insert into tb values (3,1234567890.1232);
insert into tb values (4,1234567890.1233);
--TEST:
select /*+ recompile */ * from tb where a between 1234567890.1231 and 1234567890.1233 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 1234567890.1231 and 1234567890.1233 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a DECIMAL(14,4));
insert into tb values (1,1234567890.123);
insert into tb values (2,1234567890.1231);
create index i_tb_a on tb(a);
insert into tb values (3,1234567890.1232);
insert into tb values (4,1234567890.1233);
--TEST:
select /*+ recompile */ * from tb where a between 1234567890.1231 and 1234567890.1233 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 1234567890.1231 and 1234567890.1233 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a FLOAT);
insert into tb values (1,-1.1);
insert into tb values (2,0);
create index i_tb_a on tb(a);
insert into tb values (3,0.01);
insert into tb values (4,1.013);
--TEST:
select /*+ recompile */ * from tb where a between 0 and 1.013 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 0 and 1.013 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a REAL);
insert into tb values (1,-1.1);
insert into tb values (2,0);
create index i_tb_a on tb(a);
insert into tb values (3,0.01);
insert into tb values (4,1.013);
--TEST:
select /*+ recompile */ * from tb where a between 0 and 1.013 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 0 and 1.013 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a DOUBLE);
insert into tb values (1,-1.7976931348623157E+308);
insert into tb values (2,-2.2250738585072014E-308);
create index i_tb_a on tb(a);
insert into tb values (3,2.2250738585072014E-308);
insert into tb values (4,1.7976931348623157E+308);
--TEST:
select /*+ recompile */ * from tb where a between -2.2250738585072014E-308 and 1.7976931348623157E+308 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between -2.2250738585072014E-308 and 1.7976931348623157E+308 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a DOUBLE PRECISION);
insert into tb values (1,-1.7976931348623157E+308);
insert into tb values (2,-2.2250738585072014E-308);
create index i_tb_a on tb(a);
insert into tb values (3,2.2250738585072014E-308);
insert into tb values (4,1.7976931348623157E+308);
--TEST:
select /*+ recompile */ * from tb where a between -2.2250738585072014E-308 and 1.7976931348623157E+308 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between -2.2250738585072014E-308 and 1.7976931348623157E+308 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a MONETARY);
insert into tb values (1,1.123);
insert into tb values (2,2.123);
create index i_tb_a on tb(a);
insert into tb values (3,3.123);
insert into tb values (4,4.123);
--TEST:
select /*+ recompile */ * from tb where a between 2.123 and 4.123 order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2.123 and 4.123 using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a DATE);
insert into tb values (1,DATE'2010-12-30');
insert into tb values (2,DATE'2010-12-31');
create index i_tb_a on tb(a);
insert into tb values (3,DATE'2011-01-01');
insert into tb values (4,DATE'2011-01-02');
--TEST:
select /*+ recompile */ * from tb where a between DATE'2010-12-31' and DATE'2011-01-02' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between DATE'2010-12-31' and DATE'2011-01-02' using index i_tb_a limit 1,3;
drop table tb;
    
create table tb (id int primary key, a TIME);
insert into tb values (1,TIME'22:42:00');
insert into tb values (2,TIME'22:43:00');
create index i_tb_a on tb(a);
insert into tb values (3,TIME'22:44:00');
insert into tb values (4,TIME'22:45:00');
--TEST:
select /*+ recompile */ * from tb where a between TIME'22:43:00' and TIME'22:45:00' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between TIME'22:43:00' and TIME'22:45:00' using index i_tb_a limit 1,3;
drop table tb;
    
create table tb (id int primary key, a TIMESTAMP);
insert into tb values (1,TIMESTAMP'2010-12-31 22:42:00');
insert into tb values (2,TIMESTAMP'2010-12-31 22:43:00');
create index i_tb_a on tb(a);
insert into tb values (3,TIMESTAMP'2010-12-31 22:44:00');
insert into tb values (4,TIMESTAMP'2010-12-31 22:45:00');
--TEST:
select /*+ recompile */ * from tb where a between TIMESTAMP'2010-12-31 22:43:00' and TIMESTAMP'2010-12-31 22:45:00' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between TIMESTAMP'2010-12-31 22:43:00' and TIMESTAMP'2010-12-31 22:45:00' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a DATETIME);
insert into tb values (1,DATETIME'2010-12-31 22:42:00');
insert into tb values (2,DATETIME'2010-12-31 22:43:00');
create index i_tb_a on tb(a);
insert into tb values (3,DATETIME'2010-12-31 22:44:00');
insert into tb values (4,DATETIME'2010-12-31 22:45:00');
--TEST:
select /*+ recompile */ * from tb where a between DATETIME'2010-12-31 22:43:00' and DATETIME'2010-12-31 22:45:00' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between DATETIME'2010-12-31 22:43:00' and DATETIME'2010-12-31 22:45:00' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a BIT(2));
insert into tb values (1,B'00');
insert into tb values (2,B'01');
create index i_tb_a on tb(a);
insert into tb values (3,B'10');
insert into tb values (4,B'11');
--TEST:
select /*+ recompile */ * from tb where a between B'01' and B'11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between B'01' and B'11' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a BIT VARYING(200));
insert into tb values (1,B'00');
insert into tb values (2,B'01');
create index i_tb_a on tb(a);
insert into tb values (3,B'10');
insert into tb values (4,B'11');
--TEST:
select /*+ recompile */ * from tb where a between B'01' and B'11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between B'01' and B'11' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a CHAR(2));
insert into tb values (1,'00');
insert into tb values (2,'01');
create index i_tb_a on tb(a);
insert into tb values (3,'10');
insert into tb values (4,'11');
--TEST:
select /*+ recompile */ * from tb where a between '01' and '11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between '01' and '11' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a VARCHAR(2));
insert into tb values (1,'00');
insert into tb values (2,'01');
create index i_tb_a on tb(a);
insert into tb values (3,'10');
insert into tb values (4,'11');
--TEST:
select /*+ recompile */ * from tb where a between '01' and '11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between '01' and '11' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a NCHAR(2));
insert into tb values (1,N'00');
insert into tb values (2,N'01');
create index i_tb_a on tb(a);
insert into tb values (3,N'10');
insert into tb values (4,N'11');
--TEST:
select /*+ recompile */ * from tb where a between N'01' and N'11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between N'01' and N'11' using index i_tb_a limit 1,3;
drop table tb;

create table tb (id int primary key, a NCHAR VARYING(2));
insert into tb values (1,N'00');
insert into tb values (2,N'01');
create index i_tb_a on tb(a);
insert into tb values (3,N'10');
insert into tb values (4,N'11');
--TEST:
select /*+ recompile */ * from tb where a between N'01' and N'11' order by a desc limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between N'01' and N'11' using index i_tb_a limit 1,3;
drop table tb;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
