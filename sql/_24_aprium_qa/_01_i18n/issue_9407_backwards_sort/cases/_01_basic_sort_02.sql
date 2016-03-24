set names utf8 collate utf8_fr_exp_ab;

drop table if exists t1;
create table t1(id int,s string charset utf8);
insert into t1 values
(1,'cotè')
,(2,'côtè')
,(3,'coté') 
,(4,'côté');
alter t1 add column sfr string collate utf8_fr_exp_ab;
update t1 set sfr=s;
select * from t1 order by s;
select * from t1 order by sfr;

drop t1;

create table t1(id int,s string charset utf8);
insert into t1 values
(1,'cotè')
,(2,'cOtè')
,(3,'côtè')
,(4,'cote')
,(5,'cOte')
,(6,'côte');
alter t1 add column sfr string collate utf8_fr_exp_ab;
update t1 set sfr=s;

select id,s,sfr from t1 order by s;
select id,sfr,s from t1 order by sfr;

drop t1;

set names iso88591;
