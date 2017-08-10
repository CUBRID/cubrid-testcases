-- Test Hash distribution with following collations:
-- utf8_tr_cs, utf8_ko_cs, utf8_gen, utf8_gen_ai_ci, utf8_gen_ci, utf8_es_cs, utf8_ko_cs_uca, utf8_tr_cs_uca, utf8_vi_cs, utf8_ro_cs

-- utf8_tr_cs
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_tr_cs) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_ko_cs
create table w2(a int, b varchar(100) charset utf8 collate utf8_ko_cs) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_gen
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_gen) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_gen_ai_ci
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_gen_ai_ci) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_gen_ci
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_gen_ci) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_es_cs
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_es_cs) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_ko_cs_uca
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_ko_cs_uca) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_tr_cs_uca
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_tr_cs_uca) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_vi_cs
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_vi_cs) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;

-- utf8_ro_cs
drop table if exists w2;
create table w2(a int, b varchar(100) charset utf8 collate utf8_ro_cs) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop w2;
