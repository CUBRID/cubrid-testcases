set names utf8;
create table t(s1 string collate utf8_bin,s2 string collate iso88591_bin);
insert into t values('a','b');
select s1||s2 from t;
drop table t;
set names iso88591;