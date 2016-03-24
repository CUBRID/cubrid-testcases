--+ holdcas on;
set names utf8;
drop table if exists t1,t2;
create table t1 (s1 string charset utf8 collate 'utf8_ko_cs_uca') comment='comment for charset';
insert into t1 values('a'),('cc');
show create table t1;
select * from t1 order by 1;

create table t2 (s1 string charset utf8 collate 'utf8_ko_cs_uca' comment'?????');
insert into t2 values('a'),('cc');
show create table t2;
select * from t2 order by 1;

drop table if exists t1, t2;

set names iso88591;
drop table if exists t, t1, t2;
set system parameters 'intl_date_lang = de_DE';
create table t( a DATE) comment'test it using de_DE';
create table t1( a DATE comment'comment on column attribute') comment'test it using de_DE';
create table t2( a DATE comment'comment on column''s attribute, some keywork-"table" is using') comment'test it using de_DE-"table"';
insert into t value(DATE '2012-1-22' );
insert into t1 value(DATE '05/11/2015' );
insert into t2 value(DATE '2015-5-1' );

show create table t;
show create table t1;
show create table t2;

select class_name, comment from _db_class where class_name='t';
select class_name, comment from db_class where class_name='t1';
select class_name, comment from db_class where class_name='t2';

select comment from _db_attribute where attr_name='a' order by 1;
set system parameters 'intl_date_lang = default';
drop table if exists t, t1, t2;


