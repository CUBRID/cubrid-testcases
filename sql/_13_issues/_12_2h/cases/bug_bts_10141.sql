drop table if exists t1,t2;

SET NAMES utf8 COLLATE utf8_en_cs;

CREATE TABLE t2 (a ENUM('A', 'a'), b VARCHAR(10)) collate utf8_en_ci; 

CREATE TABLE t2 (a ENUM('A', 'a'), b VARCHAR(10)); 

insert into t2 values ('A', 'A');
insert into t2 values (2, 'a');
insert into t2 values ('A', 'A');
insert into t2 values (2, 'a');

select * from t2;
show full columns from t2;

select distinct b from t2;

select distinct a from t2;

select distinct * from t2;

select distinct 1 from t2;

select distinct t2.* from t2;

drop table if exists t2;
set names iso88591 collate iso88591_bin;