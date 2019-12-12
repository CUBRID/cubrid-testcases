--exceptional cases whenuseing function as an argument


--argument of string type
select dayofweek(time_format('10:17:66', '%H:%i:%s'));
select dayofweek(to_char(datetime'1111-10-55 12:23:22.111'));


--argument of time type
select dayofweek(adddate(date'20/12/2010', 20));
select dayofweek(subdate(date'04/45/2010', 20));
select dayofweek(add_months(date'04/12/20105', -6));
select dayofweek(date('2001-10-188 10:14:25'));
select dayofweek(last_day('1898-15-06'));
select dayofweek(str_to_date('a,b,c', '%m,%d,%y'));
select dayofweek(to_date(2000));



--argument of timestamp type
select dayofweek(to_timestamp('19:39:45 BM 12/12/2012'));


--argument of datetime type
select dayofweek(timestamp('2010-10-28', 'abcabcabc'));
select dayofweek(to_datetime(123456));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select dayofweek(to_char(to_timestamp(str1))) from too;
select dayofweek(to_datetime(str1)) from too;
select dayofweek(to_timestamp(str1)) from too;

select dayofweek(to_time(str2)) from too;
select dayofweek(time_format(str2, '%H:%i:%s')) from too;


drop table too;
