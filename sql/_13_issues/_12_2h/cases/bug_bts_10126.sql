set names utf8;

drop table if exists t;
create table t(s set(string)) collate utf8_en_ci;
show full columns from t;
insert into t values({'A','A','a'});
select collation(s) from t;
select * from t;
drop t;

create table t(s set(string) collate utf8_en_ci);
create table t(s set(string collate utf8_en_ci));
insert into t values({'A','A','a'});
select * from t;
drop t;

set names iso88591;
