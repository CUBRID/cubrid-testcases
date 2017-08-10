drop table if exists t;
set names utf8;
create table t(s1 string collate utf8_gen,s2 string collate iso88591_bin);
insert into t values('年','天'),('天','');

select * from t where s1>s2 order by 1,2;
select count(s1||s2) from t;
drop t;
set names iso88591;
