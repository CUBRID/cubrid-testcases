--exceptional cases whenuseing function as an argument


--argument of string type
select dayofmonth(time_format('10:17:66', '%H:%i:%s'));
select dayofmonth(to_char(datetime'1111-10-55 12:23:22.111'));


--argument of time type
select dayofmonth(adddate(date'20/12/2010', 20));
select dayofmonth(subdate(date'04/45/2010', 20));
select dayofmonth(add_months(date'04/12/20105', -6));
select dayofmonth(date('2001-10-188 10:14:25'));
select dayofmonth(last_day('1898-15-06'));
select dayofmonth(str_to_date('a,b,c', '%m,%d,%y'));
select dayofmonth(to_date(2000));



--argument of timestamp type
select dayofmonth(to_timestamp('19:39:45 BM 12/12/2012'));


--argument of datetime type
select dayofmonth(timestamp('2010-10-28', 'abcabcabc'));
select dayofmonth(to_datetime(123456));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select dayofmonth(to_char(to_timestamp(str1))) from too;
select dayofmonth(to_datetime(str1)) from too;
select dayofmonth(to_timestamp(str1)) from too;

select dayofmonth(to_time(str2)) from too;


drop table too;
