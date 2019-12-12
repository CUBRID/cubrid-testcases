--use function as an argument


--argument of string type
select quarter(to_char(to_timestamp('19:39:45 PM 12/12/2012')));


--argument of date type
select quarter(adddate(date'04/12/2010', 20));
select quarter(subdate(date'04/12/2010', 20));
select quarter(add_months(date'04/12/2010', -6));
select quarter(date('2001-10-18 10:14:25'));
select quarter(last_day('1898-05-06'));
select quarter(str_to_date('01,5,2015', '%m,%d,%y'));
select quarter(to_date('10/10/1010'));


--argument of timestamp type
select quarter(to_timestamp('19:39:45 PM 12/12/2012'));


--argument of datetime type
select quarter(timestamp('2010-10-28', '15:49:33'));
select quarter(to_datetime('01:23:33 am 10/23/1988'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '2011-11-11');

select quarter(to_char(to_timestamp(str1))) from too;
select quarter(to_datetime(str1)) from too;
select quarter(to_timestamp(str1)) from too;

select quarter(to_date(str2)) from too;


drop table too;
