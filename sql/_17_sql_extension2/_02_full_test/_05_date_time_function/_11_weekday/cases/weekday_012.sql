--exceptional cases whenuseing function as an argument


--argument of string type
select weekday(time_format('10:17:66', '%H:%i:%s'));
select weekday(to_char(datetime'1111-10-55 12:23:22.111'));


--argument of time type
select weekday(adddate(date'20/12/2010', 20));
select weekday(subdate(date'04/45/2010', 20));
select weekday(add_months(date'04/12/20105', -6));
select weekday(date('2001-10-188 10:14:25'));
select weekday(last_day('1898-15-06'));
select weekday(str_to_date('a,b,c', '%m,%d,%y'));
select weekday(to_date(2000));



--argument of timestamp type
select weekday(to_timestamp('19:39:45 BM 12/12/2012'));


--argument of datetime type
select weekday(timestamp('2010-10-28', 'abcabcabc'));
select weekday(to_datetime(123456));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select weekday(to_char(to_timestamp(str1))) from too;
select weekday(to_datetime(str1)) from too;
select weekday(to_timestamp(str1)) from too;

select weekday(to_time(str2)) from too;
select weekday(time_format(str2, '%H:%i:%s')) from too;


drop table too;
