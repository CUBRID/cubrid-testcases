SELECT  if (bit_length('8') = bit_length(b'11111111'), 'ok', 'nok') from db_root;

$binary, $11111111
select bit_length(?) from db_root;

create table t (s varchar(255));

insert into t values('255');

insert into t values('-0');

insert into t values('-255');

select bit_length(s) from t order by s;

select bit_length(s) from t where bit_length(s) order by s;

drop table t;

select bit_length({1,2,3});

select bit_length(date'2010-01-01');

select bit_length('2010-01-01');
