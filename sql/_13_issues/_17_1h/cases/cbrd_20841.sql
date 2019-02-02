--+ holdcas on;

select to_char(cast('06:04:56.144 PM 02/23/2017' as datetime), repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200));

select to_char(cast('06:04:56.144 PM 02/23/2017' as datetime), repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',100)); 

select to_char(repeat(cast('06:04:56.144 PM 02/23/2017' as datetime),300), repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200));

SELECT TO_CHAR(TIMESTAMP'2016-10-04 22:23:00', repeat('Day Month yyyy',300),'ko_KR');

SELECT TO_CHAR(12345,repeat('S999999.9',200));

select to_date(cast('06:04:56.144 PM 02/23/2017' as datetime), repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200));

set @a=repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200);

select to_char(cast('06:04:56.144 PM 02/23/2017' as datetime),@a);


drop table if exists t;

create table t(type_char varchar);

insert into t values (repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200));   

select to_char(cast('06:04:56.144 PM 02/23/2017' as datetime),type_char) from t;

drop table t;

drop variable @a;

--+ holdcas off;
