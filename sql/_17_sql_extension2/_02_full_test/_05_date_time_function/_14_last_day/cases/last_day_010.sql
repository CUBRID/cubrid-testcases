--use function as an argument


--argument of string type
select last_day(to_char(to_timestamp('19:39:45 PM 12/12/2012')));


--argument of date type
select last_day(adddate(date'04/12/2010', 20));
select last_day(subdate(date'04/12/2010', 20));
select last_day(add_months(date'04/12/2010', -6));
select last_day(date('2001-10-18 10:14:25'));
select last_day(last_day('1898-05-06'));
select last_day(str_to_date('01,5,2015', '%m,%d,%y'));
select last_day(to_date('10/10/1010'));


--argument of timestamp type
select last_day(to_timestamp('19:39:45 PM 12/12/2012'));


--argument of datetime type
select last_day(timestamp('2010-10-28', '15:49:33'));
select last_day(to_datetime('01:23:33 am 10/23/1988'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '2011-11-11');

select last_day(to_char(to_timestamp(str1))) from too;
select last_day(to_datetime(str1)) from too;
select last_day(to_timestamp(str1)) from too;

select last_day(to_date(str2)) from too;
select last_day(str_to_date(str2, '%m,%d,%y')) from too;


drop table too;
