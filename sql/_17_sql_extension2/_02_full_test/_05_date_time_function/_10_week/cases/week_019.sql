--use function as an argument


--argument of string type
select week(to_char(to_timestamp('19:39:45 PM 12/12/2012')));


--argument of date type
select week(adddate(date'04/12/2010', 20));
select week(subdate(date'04/12/2010', 20));
select week(add_months(date'04/12/2010', -6), 3);
select week(date('2001-10-18 10:14:25'), 3+3);
select week(last_day('1898-05-06'));
select week(str_to_date('01,5,2015', '%m,%d,%y'));
select week(to_date('10/10/1010'));


--argument of timestamp type
select week(to_timestamp('19:39:45 PM 12/12/2012'), max(6));


--argument of datetime type
select week(timestamp('2010-10-28', '15:49:33'), nvl(null, 4));
select week(to_datetime('01:23:33 am 10/23/1988'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '2011-11-11');

select week(to_char(to_timestamp(str1))) from too;
select week(to_datetime(str1)) from too;
select week(to_timestamp(str1), ifnull(null, 3)) from too;

select week(to_date(str2)) from too;


drop table too;
