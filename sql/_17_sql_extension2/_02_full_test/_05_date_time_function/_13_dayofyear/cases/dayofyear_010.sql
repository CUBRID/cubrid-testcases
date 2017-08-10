--use function as an argument


--argument of string type
select dayofyear(to_char(to_timestamp('19:39:45 PM 12/12/2012')));


--argument of date type
select dayofyear(adddate(date'04/12/2010', 20));
select dayofyear(subdate(date'04/12/2010', 20));
select dayofyear(add_months(date'04/12/2010', -6));
select dayofyear(date('2001-10-18 10:14:25'));
select dayofyear(last_day('1898-05-06'));
select dayofyear(str_to_date('01,5,2015', '%m,%d,%y'));
select dayofyear(to_date('10/10/1010'));


--argument of timestamp type
select dayofyear(to_timestamp('19:39:45 PM 12/12/2012'));


--argument of datetime type
select dayofyear(timestamp('2010-10-28', '15:49:33'));
select dayofyear(to_datetime('01:23:33 am 10/23/1988'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '2011-11-11');

select dayofyear(to_char(to_timestamp(str1))) from too;
select dayofyear(to_datetime(str1)) from too;
select dayofyear(to_timestamp(str1)) from too;

select dayofyear(to_date(str2)) from too;
select dayofyear(str_to_date(str2, '%m,%d,%y')) from too;


drop table too;
