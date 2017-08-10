--exceptional cases whenuseing function as an argument


--argument of string type
select time(time_format('10:17:66', '%H:%i:%s'));
select time(to_char(datetime'1111-10-55 12:23:22.111'));


--argument of time type
select time(to_time('14:20:34.333'));


--argument of timestamp type
select time(to_timestamp('19:39:45 BM 12/12/2012'));


--argument of datetime type
select time(timestamp('2010-10-28', 'abcabcabc'));
select time(to_datetime(123456));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select time(to_char(to_timestamp(str1))) from too;
select time(to_datetime(str1)) from too;
select time(to_timestamp(str1)) from too;

select time(to_time(str2)) from too;
select time(time_format(str2, '%H:%i:%s')) from too;


drop table too;
