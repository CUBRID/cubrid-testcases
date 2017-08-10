SELECT  if ( 123>>'5' = 123>>5, 'ok', 'nok') from db_root;

$varchar, $123, $varchar, $5
select 123>>5 from db_root;

$varchar, $123, $varchar, $5
select if (?>>? = 123>>5, 'ok','nok') from db_root;

create table t (s1 varchar(255), s2 varchar(255));

insert into t values('123','5');

insert into t values('1','4');

select s1>>s2 from t order by s1,s2;

select s1>>s2 from t where s1>>s2 order by s1, s2;

drop table t;

select {1,2,3}>>'a';

select date'2010-01-01'>>2;

select '2010-01-01'>>3;