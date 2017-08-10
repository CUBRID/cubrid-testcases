select if ('1' between 0 and 2, 'ok', 'nok') from db_root;

select if ('10' between 1 and '20', 'ok', 'nok') from db_root;

$varchar, $10,  $varchar, $20
select if (? between 1 and ?, 'ok', 'nok') from db_root;

$varchar, $10, $int, $1,  $varchar, $20
select if (? between ? and ?, 'ok', 'nok') from db_root;

select if ('07:00:01 PM' between time'15:00:00' and '08:00:00 pm', 'ok','nok') from db_root;

select if ('2010-01-01 07:00:01 PM' between datetime'2010-01-01 15:00:00' and '2010-01-01 08:00:00 pm', 'ok','nok') from db_root;

create table t (s string, d date, dt datetime);

insert into t values('2010-01-01 07:00:01','2010-01-01', '2010-01-01 08:00:00 pm');

select * from t where s between d and dt;

select (s between d and dt) from t where s between d and dt;


drop table t;