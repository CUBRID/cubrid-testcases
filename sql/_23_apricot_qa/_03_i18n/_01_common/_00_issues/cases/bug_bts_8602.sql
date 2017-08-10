set names utf8;

drop table if exists t;
create table t(s string collate utf8_de_exp,index i(s(2)));
create table t(s string collate utf8_ja_exp,index i(s(2)));
create table t(s string collate utf8_km_exp,index i(s(2)));

create table t(s string collate utf8_bin,index i(s(2)));
alter table t change column s s string collate utf8_de_exp;
alter table t change column s s string collate utf8_ja_exp;
alter table t change column s s string collate utf8_km_exp;
drop t;

create table t(s string collate utf8_bin);
alter table t change column s s string collate utf8_de_exp;
create index i on t(s(2));
alter table t change column s s string collate utf8_ja_exp;
create index i on t(s(2));
alter table t change column s s string collate utf8_km_exp;
create index i on t(s(2));
drop t;

set names iso88591;
