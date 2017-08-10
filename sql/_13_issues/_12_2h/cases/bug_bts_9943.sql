
set names utf8;
drop table if exists t;

create table t(id smallint auto_increment, s enum('天','납','ê') collate utf8_gen_ai_ci);
insert into t(s) values(1),(2),(3);

select s from t where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs_uca;
select s from t where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs;

select s collate utf8_ko_cs_uca from t where s collate utf8_de_exp > 'j' order by 1;
select s collate utf8_ko_cs from t where s collate utf8_de_exp > 'j' order by 1 desc;

select s,count(*) from t group by s collate utf8_ko_cs_uca asc;
select s,count(*) from t group by s collate utf8_ko_cs desc;

create view v as select s from t where s collate utf8_de_exp > 'j';
select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs_uca;
select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs;

select s collate utf8_ko_cs_uca from v where s collate utf8_de_exp > 'j' order by 1;
select s collate utf8_ko_cs from v where s collate utf8_de_exp > 'j' order by 1 desc;

select s collate utf8_ko_cs_uca,count(*) from v group by 1 asc;
select s collate utf8_ko_cs,count(*) from v group by 1 desc;

drop t;
drop v;
set names iso88591;
