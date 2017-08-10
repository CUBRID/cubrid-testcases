drop table if exists t;
set names utf8;
create table t(id int, s string collate utf8_bin);
insert into t values(1,'金'),(2,'가');
set names iso88591;
select id,s,collation(s),collation('金'),coercibility(s),coercibility('金'),hex(s),hex(cast(_iso88591'金' as string collate utf8_bin)) from t where s > '金' order by 1;

drop t;
create table t(id int, s string);
insert into t values(1,'金'),(2,'가');
set names utf8;
select id,s,cast(s as string collate utf8_bin),collation(s),collation('金'),coercibility(s),coercibility('金'),hex(s),hex(cast(_utf8'金' as string collate iso88591_bin))   from t where s > '金';

drop t;
set names iso88591;
