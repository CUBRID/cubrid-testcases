SELECT  if (bit_count('255') = bit_count(255), 'ok', 'nok') from db_root;

$varchar, $255
select bit_count(?) from db_root;

$varchar, $-255
select if (bit_count(?) = bit_count(-2.55e2), 'ok','nok') from db_root;

create table t (s varchar(255));

insert into t values('255');

insert into t values('-0');

insert into t values('-255');

select bit_count(s) from t order by s;

select bit_count(s) from t where bit_count(s) order by s;

drop table t;

select bit_count({1,2,3});

select bit_count(date'2010-01-01');

select bit_count('2010-01-01');
