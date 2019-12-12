set names utf8;
drop table if exists t;
create table t(v1 string collate utf8_de_exp,v2 string collate utf8_bin);
insert into t values('Ä','öx'),('öx','Äx');
select * from t where v1<v2 order by 1,2;
select * from t where v1<cast(v2 as varchar collate utf8_de_exp) order by 1,2;
select * from t where substring(v1,1,1)<substring(v2,1,1)  order by 1,2;
drop t;

create table t(v1 string collate utf8_de_exp);
insert into t values('Äa'),('aä');
select * from t where v1 like '%A%' order by 1;
update t set v1=substring(v1,1,1);
select * from t order by 1;
insert into t values('ä');
select * from t where v1 like '%a%' or v1 like '%ä%' order by 1;
select * from t where v1 like 'a%' order by 1;
select * from t where v1 like 'a_' order by 1;
select * from t where cast(v1 as varchar(10) collate utf8_bin) like '%a%' order by 1; 
select cast(v1 as varchar(10) collate utf8_bin) from t order by 1;
create index ix on t(v1) where v1>='Ä';

select * from t where v1>='Ä' using index ix(+);
show full columns from t;
update statistics on t;
show indexes from t;
drop t;

create table t(v1 string collate utf8_bin,v2 string collate utf8_de_exp);
insert into t values('g','g'),('GH','GH'),('g','GH');
select cast(v1||v2 as string collate utf8_bin) as c from t where cast(v1||v2 as string collate utf8_bin)>v2 order by 1;
create reverse index ri on t(v2);

select * from t where v2 <'G'  order by 1,2;
drop reverse index ri on t (v2);
create index i on t(substring(v2,1,1)) ;
select * from t where substring(v2,1,1)<'A'  order by 1,2;
show full columns from t;
drop t;
set names iso88591;
