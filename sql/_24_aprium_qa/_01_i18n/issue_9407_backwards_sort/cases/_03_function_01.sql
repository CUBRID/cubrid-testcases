set names utf8 collate utf8_fr_exp_ab;
select 1 from db_class where 'CàUOIE'>'cauoie' limit 1;
set names utf8;
select 1 from db_class where 'CàUOIE'>'cauoie' limit 1;

drop table if exists t;
create table t(id int auto_increment,v char(10) collate utf8_fr_exp_ab);
insert into t(v) values
('cauoie')
,('CAuoîê')
,('caùôIe')
,('cäùoiE')
,('Càüôîe')
,('CäUOîe')
,('çäüôIê')
,('çàuoie')
,('cAUôiè')
,('CàUOIE')
,('çaùOîé')
,('cauOIè')
,('cäüoîè')
,('CàùOiê')
,('caUoIé')
,('càùoîè')
,('cAüOIe')
,('çaUôiê')
,('Cäuôié')
,('çAùôié')
,('çaüOiè')
,('CauôîE')
,('cAùOîê');

select id,substr(v,1,5) from t order by 2 desc;

select left(v,3)||'é' from t order by left(v,3)||'é';
select right(v,3) from t order by 1;
drop t;

create table t(id int,s string collate utf8_fr_exp_ab);
insert into t values(1,'xcôté'),(2,'xcôtê');
select * from t where s like '_côté' order by 1;
select replace(s,'é','e') from t order by 1;
drop t;

set names iso88591;
