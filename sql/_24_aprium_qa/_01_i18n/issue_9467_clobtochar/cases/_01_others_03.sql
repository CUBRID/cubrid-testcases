set names utf8 collate utf8_en_ci;

drop table if exists t;
select * from db_class where chr(65) like '%a%' limit 1;
set names utf8;
select * from db_class where chr(65)||chr(97) collate utf8_en_ci like '%a%' limit 1;
select substr(chr(65)||chr(97),2,1) collate utf8_en_ci from db_class where substr(chr(65)||chr(97),2,1) collate utf8_en_ci like 'A%' limit 1;
select substr(chr(65)||chr(97),2,1) collate utf8_en_ci from db_class where substr(chr(65)||chr(97),2,1) collate utf8_en_cs like 'A%' limit 1;

set names iso88591;
create table t(id int,c clob);
insert into t values(1,'a'),(2,'b');
create view v as select clob_to_char(c using utf8) as c from t;
create view v2 as select clob_to_char(c using utf8) collate utf8_de_exp as c from t;

drop t;
drop v;
drop v2;
