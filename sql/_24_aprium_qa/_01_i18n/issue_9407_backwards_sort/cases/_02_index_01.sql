set names utf8 collate utf8_fr_exp_ab;

drop table if exists t;
create table t(id int auto_increment,v varchar(10) collate utf8_fr_exp_ab);
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

create reverse index ri on t(v);
insert into t values(null,'çAüOiE'),(null,'CaùôIè');
select * from t order by 2 desc;

delete from t where v='çàuoie' or v='çaùOîé';
drop reverse index ri on t;
create index i on t(v) where v>'cauOIè';
insert into t values(null,'çàuoie'),(null,'çaùOîé');
select * from t using index i(+) order by 2;

drop t;

set names iso88591;
