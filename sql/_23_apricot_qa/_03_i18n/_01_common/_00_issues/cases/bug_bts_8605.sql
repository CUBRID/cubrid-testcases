drop table if exists t;
set names utf8;
create table t(s1 string collate utf8_bin,s2 string collate utf8_ko_cs_uca);
insert into t values('年','年'),('大','大'),('天','天');

select * from t where s1 between '年' and s2 order by s1;
select * from t where s1 between s2 and '年' order by s1;
select * from t where s2 between s1 and '年' order by s1;
select * from t where s2 between '年' and s1 order by s1;
select * from t where '年' between s1 and s2 order by s1;
select * from t where '年' between s2 and s1 order by s1;

drop t;
set names iso88591;
