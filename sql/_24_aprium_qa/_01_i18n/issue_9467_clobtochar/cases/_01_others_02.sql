set names utf8;

drop table if exists t;
create table t(id int,c clob);
insert into t values(1,'袂');
insert into t values(2,'里');
insert into t values(3,'金');
insert into t values(4,'가');
insert into t values(5,'간');
insert into t values(6,'끽');
insert into t values(7,'납');
insert into t values(8,'a');

select id,clob_to_char(c using utf8) from t order by 2;
select id,clob_to_char(c using utf8) collate utf8_ko_cs from t order by 2;
select id,clob_to_char(c using utf8) collate utf8_ko_cs_uca from t order by 2;
select id,clob_to_char(c using utf8) from t where clob_to_char(c using utf8) collate utf8_en_cs like 'A' order by 2;

create view v as select id as id,clob_to_char(c using utf8) collate utf8_ko_cs as s1 from t;
create index ri on t(clob_to_char(c));
select * from v order by s1 collate utf8_ko_cs_uca;

drop t;
drop v;

set names iso88591;
