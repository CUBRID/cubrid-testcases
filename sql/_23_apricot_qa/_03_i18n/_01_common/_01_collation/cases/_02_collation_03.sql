drop table if exists tt;
drop table if exists t;
drop table if exists temp;
drop table if exists 등;

set names utf8;
create table tt(v string collate utf8_de_exp);
create table temp(v string collate iso88591_bin);
alter table temp change v v string collate utf8_de_exp;
drop temp;
drop tt;

create table t(v string collate utf8_ko_cs_uca not null);
insert into t values('등'),('烙a등량'),('량라');
select * from t order by 1 ;
select * from t where v like '%등%' order by 1 desc;
rename table t to 등;
select * from 등 where v like '%등%' order by 1;
show full columns from 등;
alter table 등 alter column v set default '등';
insert into 등 values(NULL);
insert into 등 values(default);
select * from 등 order by 1;
drop 등;

create table t(v1 string collate utf8_bin,v2 string collate utf8_ko_cs_uca);
insert into t values('天','年'),('年','天');
create index i1 on t(v1);
create reverse index i2 on t(v2);
select * from t where v1>='天' order by 1;
select * from t where v2>='年' order by 2;
alter table t change v1 v1 varchar(3) collate utf8_ko_cs_uca;
alter table t change v2 v2 varchar(3) collate utf8_bin;
select * from t where v1>='天' order by 1;
select * from t where v2>='年' order by 2;
select * from t order by 1;
select * from t order by 2;
select * from t where v1>v2 order by 1;
select * from t where v1<v2 order by 1;
drop t;

set names iso88591;

