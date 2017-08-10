--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(i smallint,v varchar(10) charset utf8,c char(10) collate utf8_ko_cs_uca);
insert into t values(1,'工','工');
select * from t where not v collate utf8_gen <> c collate utf8_gen;

drop t;
create table t(id smallint auto_increment, s enum('天','납','ê') collate utf8_gen_ai_ci);
insert into t(s) values(1),(2),(3);
select s from t where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs_uca;
select s from t where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs;

drop t;
create table t(id smallint auto_increment, s enum('天','납','ê') collate utf8_gen_ai_ci);
create index i1 on t(s);
create index i2 on t(s collate utf8_ko_cs_uca);
create index i3 on t(s collate utf8_ko_cs);
create index i4 on t(substr(s collate utf8_ko_cs,2,1));
drop index i1 on t;
create index i5 on t(s) where s collate utf8_ko_cs >'天';
insert into t(s) values(1),(2),(3);
select * from db_index where have_function='YES' order by 1;
select * from db_index where filter_expression is not null;
show indexes from t;

drop t;

set names iso88591;
commit;
--+ holdcas off;
