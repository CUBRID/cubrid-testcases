--exceptional cases whenuseing function as an argument


--argument of string type
select minute(time_format('10:17:66', '%H:%i:%s'));
select minute(to_char(datetimetz'1111-10-55 12:23:22.111 Asia/Seoul'));


--argument of time type
select minute(to_time_tz('14:20:34.333 Europe/London');


--argument of timestamp type
select minute(to_timestamp_tz('19:39:45 BM 12/12/2012 Europe/London'));


--argument of datetime type
select minute(to_datetime_tz(123456));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select minute(to_char(to_timestamp_tz(str1))) from too;
select minute(to_datetime_tz(str1)) from too;
select minute(to_timestamp_tz(str1)) from too;

select minute(to_time_tz(str2)) from too;
select minute(time_format(str2, '%H:%i:%s')) from too;


drop table too;
