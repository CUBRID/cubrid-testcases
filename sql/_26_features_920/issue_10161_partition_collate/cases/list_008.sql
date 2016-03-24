set names utf8;

CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('a'), ('A');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate euckr_bin)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate iso88591_bin)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate iso88591_en_ci primary key)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate iso88591_en_cs primary key)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;
 

CREATE TABLE t1 (a VARCHAR (30) collate utf8_bin primary key)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_de_exp primary key)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;

 
CREATE TABLE t1 (a VARCHAR (30) collate utf8_de_exp_ai_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;
 


CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;

 
CREATE TABLE t1 (a VARCHAR (30) collate utf8_en_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_es_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;

 
CREATE TABLE t1 (a VARCHAR (30) collate utf8_fr_exp_ab)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;

 

CREATE TABLE t1 (a VARCHAR (30) collate utf8_gen)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_gen_ai_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_gen_ci)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_ja_exp)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_ja_exp_cbm)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_km_exp)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_ko_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;


CREATE TABLE t1 (a VARCHAR (30) collate utf8_ko_cs_uca)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_ro_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_tr_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_tr_cs_uca)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (a VARCHAR (30) collate utf8_vi_cs)
PARTITION BY LIST (a) (
    PARTITION a1 VALUES IN ('A')
);
insert into t1 values ('A');
insert into t1 values ('a');
select * from t1 order by 1;
drop table t1;

set names iso88591;