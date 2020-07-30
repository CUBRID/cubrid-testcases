--+ holdcas on;
set names utf8;
drop table if exists t;

create table t(v1 string collate utf8_bin);
insert into t values('天'),('年');
select * from t order by 1;
create reverse index ri on t(v1);
alter table t change v1 v1 varchar(3) collate utf8_ko_cs_uca;
select * from t order by 1;
select /*+ recompile*/ * from t where v1>='天' order by 1;
select /*+ recompile*/ * from t where v1<='天' order by 1;
drop t;

create table t(v1 varchar(10) collate utf8_bin);
insert into t values('天'),('年');
create index ri on t(v1);
alter table t change v1 v1 varchar(3) collate utf8_ko_cs_uca;
select * from t order by 1;
select /*+ recompile*/ * from t where v1>='天' order by 1;
select /*+ recompile*/ * from t where v1<='天' order by 1;
drop t;

create table t(v1 varchar(10) collate utf8_bin,v2 char(10) collate utf8_bin);
insert into t values('天','年'),('年','天');
create reverse index ri on t(v1,v2);
alter table t change v1 v1 varchar(3) collate utf8_ko_cs_uca;
alter table t change v2 v2 varchar(10) collate utf8_ko_cs_uca;

select * from t order by 1;
select /*+ recompile*/ * from t where v1>='天' order by 1;
select /*+ recompile*/ * from t where v1<='天' order by 1;
select /*+ recompile*/ * from t where v2>='天' order by 1;
select /*+ recompile*/ * from t where v2<='天' order by 1;
drop t;

create table t(v1 string collate utf8_ko_cs_uca);
insert into t values('天'),('年');
select * from t order by 1;
create reverse index ri on t(v1);
alter table t change v1 v1 varchar(3) collate utf8_bin;
select * from t order by 1;
select /*+ recompile*/ * from t where v1>='天' order by 1;
select /*+ recompile*/ * from t where v1<='天' order by 1;
drop t;
set names iso88591;
--+ holdcas off;
