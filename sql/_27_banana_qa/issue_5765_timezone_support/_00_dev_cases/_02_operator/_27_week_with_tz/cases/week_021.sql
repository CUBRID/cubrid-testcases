--exceptional cases whenuseing function as an argument


--argument of string type
select week(time_format('10:17:66', '%H:%i:%s'));
select week(to_char(datetimetz'1111-10-55 12:23:22.111'), 3);

--argument of timestamp type
select week(to_timestamp_tz('19:39:45 BM 12/12/2012 Europe/London'));
select week(to_timestamp_tz('19:39:45 BM 12/12/2012 Europe/London'), least(to_date('2010-10-10'), '222222'));


--argument of datetime type
select week(to_datetime_tz(123456), ifnull(null, null));


--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select week(to_char(to_timestamp_tz(str1))) from too;
select week(to_datetime_tz(str1), floor(2.200010101010101333)) from too;
select week(to_timestamp_tz(str1)) from too;

select week(to_time_tz(str2), round(22222.3434343)) from too;
select week(time_format(str2, '%H:%i:%s')) from too;


drop table too;
