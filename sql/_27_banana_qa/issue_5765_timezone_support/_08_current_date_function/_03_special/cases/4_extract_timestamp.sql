set timezone 'America/New_York';
select if (extract(year from current_timestamp)=year(current_timestamp),'ok','nok');
select if (extract(year from current_timestamp())=year(current_timestamp()),'ok','nok');
select if (extract(year from localtime())=year(localtime()),'ok','nok');
select if (extract(year from localtime)=year(localtime),'ok','nok');
select if (extract(year from localtimestamp)=year(localtimestamp),'ok','nok');
select if (extract(year from localtimestamp())=year(localtimestamp()),'ok','nok');
select if (extract(year from systimestamp)=year(systimestamp),'ok','nok');
select if (extract(year from sys_timestamp)=year(sys_timestamp),'ok','nok');




select if (extract(month from current_timestamp)=month(current_timestamp),'ok','nok');
select if (extract(month from current_timestamp())=month(current_timestamp()),'ok','nok');
select if (extract(month from localtime())=month(localtime()),'ok','nok');
select if (extract(month from localtime)=month(localtime),'ok','nok');
select if (extract(month from localtimestamp)=month(localtimestamp),'ok','nok');
select if (extract(month from localtimestamp())=month(localtimestamp()),'ok','nok');
select if (extract(month from systimestamp)=month(systimestamp),'ok','nok');
select if (extract(month from sys_timestamp)=month(sys_timestamp),'ok','nok');


select if (extract(day from current_timestamp)=day(current_timestamp),'ok','nok');
select if (extract(day from current_timestamp())=day(current_timestamp()),'ok','nok');
select if (extract(day from localtime())=day(localtime()),'ok','nok');
select if (extract(day from localtime)=day(localtime),'ok','nok');
select if (extract(day from localtimestamp)=day(localtimestamp),'ok','nok');
select if (extract(day from localtimestamp())=day(localtimestamp()),'ok','nok');
select if (extract(day from systimestamp)=day(systimestamp),'ok','nok');
select if (extract(day from sys_timestamp)=day(sys_timestamp),'ok','nok');



select if (extract(hour from current_timestamp)=hour(current_timestamp),'ok','nok');
select if (extract(hour from current_timestamp())=hour(current_timestamp()),'ok','nok');
select if (extract(hour from localtime())=hour(localtime()),'ok','nok');
select if (extract(hour from localtime)=hour(localtime),'ok','nok');
select if (extract(hour from localtimestamp)=hour(localtimestamp),'ok','nok');
select if (extract(hour from localtimestamp())=hour(localtimestamp()),'ok','nok');
select if (extract(hour from systimestamp)=hour(systimestamp),'ok','nok');
select if (extract(hour from sys_timestamp)=hour(sys_timestamp),'ok','nok');

select if (extract(minute from current_timestamp)=minute(current_timestamp),'ok','nok');
select if (extract(minute from current_timestamp())=minute(current_timestamp()),'ok','nok');
select if (extract(minute from localtime())=minute(localtime()),'ok','nok');
select if (extract(minute from localtime)=minute(localtime),'ok','nok');
select if (extract(minute from localtimestamp)=minute(localtimestamp),'ok','nok');
select if (extract(minute from localtimestamp())=minute(localtimestamp()),'ok','nok');
select if (extract(minute from systimestamp)=minute(systimestamp),'ok','nok');
select if (extract(minute from sys_timestamp)=minute(sys_timestamp),'ok','nok');


select if (extract(second from current_timestamp)=second(current_timestamp),'ok','nok');
select if (extract(second from current_timestamp())=second(current_timestamp()),'ok','nok');
select if (extract(second from localtime())=second(localtime()),'ok','nok');
select if (extract(second from localtime)=second(localtime),'ok','nok');
select if (extract(second from localtimestamp)=second(localtimestamp),'ok','nok');
select if (extract(second from localtimestamp())=second(localtimestamp()),'ok','nok');
select if (extract(second from systimestamp)=second(systimestamp),'ok','nok');
select if (extract(second from sys_timestamp)=second(sys_timestamp),'ok','nok');

select if (extract(millisecond from current_timestamp)=extract(millisecond from current_timestamp()),'ok','nok');


set timezone '+08:00';
select if (extract(year from current_timestamp)=year(current_timestamp),'ok','nok');
select if (extract(year from current_timestamp())=year(current_timestamp()),'ok','nok');
select if (extract(year from localtime())=year(localtime()),'ok','nok');
select if (extract(year from localtime)=year(localtime),'ok','nok');
select if (extract(year from localtimestamp)=year(localtimestamp),'ok','nok');
select if (extract(year from localtimestamp())=year(localtimestamp()),'ok','nok');
select if (extract(year from systimestamp)=year(systimestamp),'ok','nok');
select if (extract(year from sys_timestamp)=year(sys_timestamp),'ok','nok');




select if (extract(month from current_timestamp)=month(current_timestamp),'ok','nok');
select if (extract(month from current_timestamp())=month(current_timestamp()),'ok','nok');
select if (extract(month from localtime())=month(localtime()),'ok','nok');
select if (extract(month from localtime)=month(localtime),'ok','nok');
select if (extract(month from localtimestamp)=month(localtimestamp),'ok','nok');
select if (extract(month from localtimestamp())=month(localtimestamp()),'ok','nok');
select if (extract(month from systimestamp)=month(systimestamp),'ok','nok');
select if (extract(month from sys_timestamp)=month(sys_timestamp),'ok','nok');


select if (extract(day from current_timestamp)=day(current_timestamp),'ok','nok');
select if (extract(day from current_timestamp())=day(current_timestamp()),'ok','nok');
select if (extract(day from localtime())=day(localtime()),'ok','nok');
select if (extract(day from localtime)=day(localtime),'ok','nok');
select if (extract(day from localtimestamp)=day(localtimestamp),'ok','nok');
select if (extract(day from localtimestamp())=day(localtimestamp()),'ok','nok');
select if (extract(day from systimestamp)=day(systimestamp),'ok','nok');
select if (extract(day from sys_timestamp)=day(sys_timestamp),'ok','nok');



select if (extract(hour from current_timestamp)=hour(current_timestamp),'ok','nok');
select if (extract(hour from current_timestamp())=hour(current_timestamp()),'ok','nok');
select if (extract(hour from localtime())=hour(localtime()),'ok','nok');
select if (extract(hour from localtime)=hour(localtime),'ok','nok');
select if (extract(hour from localtimestamp)=hour(localtimestamp),'ok','nok');
select if (extract(hour from localtimestamp())=hour(localtimestamp()),'ok','nok');
select if (extract(hour from systimestamp)=hour(systimestamp),'ok','nok');
select if (extract(hour from sys_timestamp)=hour(sys_timestamp),'ok','nok');

select if (extract(minute from current_timestamp)=minute(current_timestamp),'ok','nok');
select if (extract(minute from current_timestamp())=minute(current_timestamp()),'ok','nok');
select if (extract(minute from localtime())=minute(localtime()),'ok','nok');
select if (extract(minute from localtime)=minute(localtime),'ok','nok');
select if (extract(minute from localtimestamp)=minute(localtimestamp),'ok','nok');
select if (extract(minute from localtimestamp())=minute(localtimestamp()),'ok','nok');
select if (extract(minute from systimestamp)=minute(systimestamp),'ok','nok');
select if (extract(minute from sys_timestamp)=minute(sys_timestamp),'ok','nok');


select if (extract(second from current_timestamp)=second(current_timestamp),'ok','nok');
select if (extract(second from current_timestamp())=second(current_timestamp()),'ok','nok');
select if (extract(second from localtime())=second(localtime()),'ok','nok');
select if (extract(second from localtime)=second(localtime),'ok','nok');
select if (extract(second from localtimestamp)=second(localtimestamp),'ok','nok');
select if (extract(second from localtimestamp())=second(localtimestamp()),'ok','nok');
select if (extract(second from systimestamp)=second(systimestamp),'ok','nok');
select if (extract(second from sys_timestamp)=second(sys_timestamp),'ok','nok');

select if (extract(millisecond from systimestamp)=extract(millisecond from sys_timestamp()),'ok','nok');
set timezone 'Asia/Seoul';
