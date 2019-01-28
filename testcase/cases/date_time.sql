drop table if exists foo;
create table foo as
with cte as( 
SELECT DATE_FORMAT (datetimetz'2012-02-02 10:10:10 Europe/Zurich CET', '%TZR %TZD %TZH %TZM')
) select * from (select * from cte) as x(ts);

select * from foo;

drop table if exists foo;


drop table if exists foo;
create table foo as
with cte as( 
SELECT STR_TO_DATE ('2001-10-11 02:03:04 AM Europe/Bucharest EEST', '%Y-%m-%d %h:%i:%s %p %TZR %TZD')
) select * from (select * from cte) as x(ts);

select * from foo;

drop table if exists foo;


drop table if exists foo;
create table foo as
with cte as( 
SELECT TO_CHAR (datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST')
) select * from (select * from cte) as x(ts);

select * from foo;

drop table if exists foo;


drop table if exists foo;
create table foo as
with cte as( 
SELECT TO_DATETIME_TZ ('2001-10-11 02:03:04 AM Europe/Bucharest EEST')
) select * from (select * from cte) as x(ts);

select * from foo;

drop table if exists foo;

drop table if exists foo;
create table foo as
with cte as( 
SELECT TO_TIMESTAMP_TZ ('2001-10-11 02:03:04 AM Europe/Bucharest')
) select * from (select * from cte) as x(ts);

select * from foo;

drop table if exists foo;
