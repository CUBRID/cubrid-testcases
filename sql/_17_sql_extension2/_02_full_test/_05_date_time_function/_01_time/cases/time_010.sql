--use function as an argument


--argument of string type
select time(time_format('10:17:56', '%H:%i:%s'));
select time(to_char(datetime'1989-10-12 12:23:22.111'));


--argument of time type
select time(to_time('14:20:34'));


--argument of timestamp type
select time(to_timestamp('19:39:45 PM 12/12/2012'));


--argument of datetime type
select time(timestamp('2010-10-28', '15:49:33'));
select time(to_datetime('01:23:33 am 10/23/1988'));



--server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '14:20:34');

select time(to_char(to_timestamp(str1))) from too;
select time(to_datetime(str1)) from too;
select time(to_timestamp(str1)) from too;

select time(to_time(str2)) from too;
select time(time_format(str2, '%H:%i:%s')) from too;


drop table too;
