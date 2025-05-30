--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(i int,s1 string, s2 string collate binary);
insert into t values(1,'TRY','TRY'),(2,'ş','ş'),(3,'İ','İ'),(4,'ı','ı'),(5,'i','i'),(6,'I','I');
select collation(distinct s2 collate binary),charset(distinct s2 collate binary) from t order by 1;
drop t;

drop table if exists t;
create table t(s1 string charset binary,s2 string collate utf8_tr_cs_uca);
insert into t values('TRY','TRY'),('ş','ş');
select charset(concat(s1,s2 collate utf8_tr_cs)),collation(concat(s1,s2 collate utf8_tr_cs)),coercibility(concat(s1,s2 collate utf8_tr_cs)) from t order by 1;
select charset(concat(s1,s2 collate utf8_bin)),collation(concat(s1,s2 collate utf8_bin)),coercibility(concat(s1,s2 collate utf8_bin)) from t order by 1;
select charset(concat(s1 collate binary,s2)),collation(concat(s1 collate binary,s2)),coercibility(concat(s1 collate binary,s2)) from t order by 1;
select collation('TRY'||(s1 collate binary)) from t order by 1; 
drop t;

drop table if exits t;
create table t(s string charset binary);
insert into t values('D'),('d'),('a');
select case when s>'¥' collate iso88591_en_ci then 'big' when s<'¥' then 'small' end from t;
prepare st from 'select case when s>? collate iso88591_en_ci then 1 when s<? then 2 end from t;';
deallocate prepare st;
drop t;

-- sub-table
set names binary;
select collation(t1.k),coercibility(t1.k) from (select 'ß' as k union select 'SS' as k union select 'ss' as k) t1 group by t1.k collate binary;
set names binary;
select collation(t1.k),coercibility(t1.k) from (select 'ß' as k union select 'SS' as k union select 'ss' as k) t1 group by t1.k collate binary;

select t1.c1,t1.c2 from (select _utf8'A' collate utf8_de_exp as c1,'AE' collate binary as c2) t1 where coercibility(t1.c1)<coercibility(t1.c2); 
select t1.c1,t1.c2,collation(t1.c1),charset(t1.c2) from (select 'Ä' collate binary as c1,'AE' collate binary as c2) t1; 
select collation (distinct * collate iso88591_en_cs) from (select 'A' union select 'a' union select 'D' union select '0') t1 order by 1 desc;

select charset(t1.s collate binary) from (select '¥' as s union select '你' union select  '好') t1 order by 1 desc;

-- UNION
set names binary;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
create table t1(col varchar(10) charset binary);
create table t2(col varchar(10) charset euckr);
insert into t1 values(_utf8'你好');
insert into t2 values(_utf8'안녕하세요');
create table t3 as select * from t1 union select * from t2;
select charset(col) from t3;
set names iso88591;
drop table t1,t2,t3;
commit;
--+ holdcas off;
