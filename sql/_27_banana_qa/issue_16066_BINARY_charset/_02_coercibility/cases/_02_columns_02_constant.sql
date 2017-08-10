--+ holdcas on;
drop table if exists t;
set names utf8;
create table t(id int, s string collate utf8_bin);
insert into t values(1,'金'),(2,'가');

set names binary;
select id,s,collation(s),collation('金'),coercibility(s),coercibility('金') from t where s > '金' order by 1;

drop t;
create table t(id int, s string collate binary);
insert into t values(1,'金'),(2,'가');
set names utf8;
select id,s,collation(s),collation('金'),coercibility(s),coercibility('金') from t where s > '金';

drop t;
set names iso88591;
commit;
--+ holdcas off;

