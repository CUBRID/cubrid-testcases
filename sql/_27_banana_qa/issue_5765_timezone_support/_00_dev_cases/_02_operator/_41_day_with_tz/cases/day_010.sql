--use function as an argument


--argument of string type
select day(to_char(to_timestamp_tz('19:39:45 PM 12/12/2012 Europe/London')));


--argument of timestamp type
select day(to_timestamp_tz('19:39:45 PM 12/12/2012 Europe/London'));


--argument of datetime type
select day(to_datetime_tz('01:23:33 am 10/23/1988 Europe/London'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012 Europe/London', '2011-11-11');

select day(to_char(to_timestamp_tz(str1))) from too;
select day(to_datetime_tz(str1)) from too;
select day(to_timestamp_tz(str1)) from too;

select day(to_date(str2)) from too;


drop table too;
