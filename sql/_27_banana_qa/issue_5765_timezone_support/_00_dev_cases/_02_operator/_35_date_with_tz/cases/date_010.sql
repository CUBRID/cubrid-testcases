--use function as an argument


--argument of string type
select date(to_char(datetimetz'1989-10-12 12:23:22.111'));


--argument of time type
select date(to_time_tz('10:10:10 Europe/London'));


--argument of timestamp type
select date(to_timestamp_tz('19:39:45 PM 12/12/2012 Europe/London'));


--argument of datetime type
select date(to_datetime_tz('01:23:33 am 10/23/1988 Europe/London'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012 Europe/London', '10:10:10');

select date(to_char(to_timestamp_tz(str1))) from too;
select date(to_datetime_tz(str1)) from too;
select date(to_timestamp_tz(str1)) from too;

select date(to_time_tz(str2)) from too;
select date(time_format(str2, '%H:%i:%s')) from too;


drop table too;
