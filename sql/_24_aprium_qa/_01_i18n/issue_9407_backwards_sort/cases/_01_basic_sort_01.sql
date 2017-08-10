set names utf8 collate utf8_fr_exp_ab;
select * from (select _utf8'cote' union select _utf8'coté' union select _utf8'côte' union select _utf8'côté') order by 1;
set names utf8;
select * from (select _utf8'cote' union select _utf8'coté' union select _utf8'côte' union select _utf8'côté') order by 1;

drop table if exists t;
create table t(s1 string charset utf8, s2 string collate utf8_fr_exp_ab);
insert into t values('cote','cote'),('coté','coté'),('côte','côte'),('côté','côté');
select * from t order by 1;
select * from t order by 2;

select s1||s2 from t order  by 1;
select s1||s2 from t order  by 1 desc;

create reverse index ri on t(s2);
select * from t order by 2 desc;
select * from t where s1+s2 like '%o%' order by 2;
select cast(s1 as string collate utf8_fr_exp_ab) from t union select s2 from t order by 1;

create view v as select s2 from t where s2 <'côte';
alter table t change column s2 s2 string charset utf8;
select s2 from v order by 1;

drop t;
drop v;
set names iso88591;
