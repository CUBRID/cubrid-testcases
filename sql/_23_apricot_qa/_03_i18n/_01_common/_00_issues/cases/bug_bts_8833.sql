set names utf8;
drop table if exists t;
create table t(s string collate utf8_bin);
insert into t values('a'),('b');
create index i on t(s);
alter table t change s s string collate utf8_de_exp;
update statistics on t;
show indexes from t;
select * from t order by 1;
drop t;

create table t(s string collate utf8_bin);
insert into t values('a'),('b');
create unique index i on t(s);
alter table t change s s string collate utf8_ja_exp;
update statistics on t;
show indexes from t;
select * from t order by 1;
drop t;

create table t(s string collate utf8_bin);
insert into t values('a'),('b');
create reverse index i on t(s);
alter table t change s s string collate utf8_km_exp;
update statistics on t;
show indexes from t;
select * from t order by 1;
drop t;

create table t(s string collate utf8_bin);
insert into t values('a'),('b');
create index i on t(s);
alter table t change s s string collate utf8_ko_cs_uca;
update statistics on t;
show indexes from t;
select * from t order by 1;
drop t;

set names iso88591;
