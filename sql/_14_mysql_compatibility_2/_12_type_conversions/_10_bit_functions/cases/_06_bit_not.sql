SELECT  if (~8 = ~'8', 'ok', 'nok') from db_root;

$varchar, $8
select ~? from db_root;

create table t (s varchar(255));

insert into t values('255');

insert into t values('-0');

insert into t values('-255');

select ~s from t order by s;

select ~s from t where ~s order by s;

drop table t;

select ~{1,2,3};

select ~date'2010-01-01';

select ~'2010-01-01';