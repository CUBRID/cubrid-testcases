--+ holdcas on;
set names utf8;
create table t(a string collate utf8_ko_cs_uca);
insert into t values('가'),('伽');
set names utf8 collate utf8_gen;
select * from t where a>'가';
drop table t;

create table t(a string collate utf8_ko_cs_uca);
insert into t values('가');
set names utf8 collate utf8_gen;
insert into t values('伽');
select * from t where a>'가';
drop table t;

create table t(a string collate utf8_ko_cs_uca,b string);
insert into t values('가','가');
set names utf8 collate utf8_gen;
insert into t values('伽','伽');
select * from t where a>b;
select * from t t1,t t2 where t1.a>t2.b;
select a+b from t ;
--CUBRIDSUS-17811
select a+'1'+b from t ;
drop table t;


create table t(a string collate utf8_ko_cs_uca);
insert into t values('가');
set names iso88591;
insert into t values('伽');
select * from t ;
drop table t;


create table t(a string charset iso88591);
insert into t values('가');
insert into t values('伽');
set names utf8 collate utf8_gen;
select * from t where a<='가';
drop table t;
set names iso88591;
commit;
--+ holdcas off;
