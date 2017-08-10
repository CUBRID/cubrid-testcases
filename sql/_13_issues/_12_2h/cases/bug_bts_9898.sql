set names utf8;

drop table if exists t;
create table t(s1 string collate utf8_ko_cs, s2 string collate utf8_ko_cs_uca);
insert into t values('a','a');

select collation('a'||s1),collation(s2) from t;
select 'a'||s1||s2 from t;
select s1||'a'||s2 from t;
select s1||s2||'a' from t;
select s1 collate utf8_ko_cs || s2 || 'a' from t;
select s1 + s2 collate utf8_ko_cs + 'a' from t;

drop t;
set names iso88591;
