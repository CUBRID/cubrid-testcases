drop table if exists t;
set names utf8;
create table t(v1 string collate utf8_ko_cs_uca,v2 string collate iso88591_bin );
show full columns from t;
insert into t values(_utf8'大',_utf8'年'),(_utf8'年',_utf8'大');
select * from t order by 1;
select * from t order by v2;
select * from t where v1 < v2; 
drop t;
set names iso88591;
