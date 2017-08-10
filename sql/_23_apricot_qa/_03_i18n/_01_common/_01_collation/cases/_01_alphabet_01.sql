drop table if exists t;
set names utf8;
create table t(id int,v1 string collate utf8_tr_cs_uca,v2 string collate utf8_de_exp);
insert into t values(1,'ö','ö');
insert into t values(2,'ı','ı');
insert into t values(3,'İ','İ');
insert into t values(4,'i','i');
insert into t values(5,'I','I');

select id,lower(v1),lower(v2),upper(v1),upper(v2) from t order by 1;
select id,v1,v2,lower(v1),lower(cast(v2 as string collate utf8_tr_cs_uca)),upper(v1),upper(cast(v2 as string collate utf8_tr_cs_uca)) from t order by 1;
select id,v1,v2,lower(cast(v1 as string collate utf8_de_exp)),lower(v2),upper(cast(v1 as string collate utf8_de_exp)),upper(v2) from t order by 1; 
delete from t;

insert into t values(6,'SS','SS'),(7,'ß','ß');
select id,lower(v1),lower(v2),upper(v1),upper(v2) from t order by 1;
select id,v1,v2,lower(v1),lower(cast(v2 as string collate utf8_tr_cs_uca)),upper(v1),upper(cast(v2 as string collate utf8_tr_cs_uca)) from t order by 1;
select id,v1,v2,lower(cast(v1 as string collate utf8_de_exp)),lower(v2),upper(cast(v1 as string collate utf8_de_exp)),upper(v2) from t order by 1;
drop t;
set names iso88591;
