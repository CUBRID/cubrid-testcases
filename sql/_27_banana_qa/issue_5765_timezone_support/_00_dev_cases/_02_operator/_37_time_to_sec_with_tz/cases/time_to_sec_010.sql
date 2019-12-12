--use function as an argument


--argument of string type
select time_to_sec(time_format('10:17:56', '%H:%i:%s'));
select time_to_sec(to_char(datetimetz'1989-10-12 12:23:22.111'));


--argument of time type
select time_to_sec(to_time_tz('14:20:34 Europe/London'));


--argument of timestamp type
select time_to_sec(to_timestamp_tz('19:39:45 PM 12/12/2012 Europe/London'));


--argument of datetime type
select time_to_sec(to_datetime_tz('01:23:33 am 10/23/1988 Europe/London'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012 Europe/London', '10:10:10');

select time_to_sec(to_char(to_timestamp_tz(str1))) from too;
select time_to_sec(to_datetime_tz(str1)) from too;
select time_to_sec(to_timestamp_tz(str1)) from too;

select time_to_sec(to_time_tz(str2)) from too;
select time_to_sec(time_format(str2, '%H:%i:%s')) from too;


drop table too;
