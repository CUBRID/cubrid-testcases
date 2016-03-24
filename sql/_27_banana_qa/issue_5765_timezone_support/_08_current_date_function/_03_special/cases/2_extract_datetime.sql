set timezone 'America/New_York';
select if (extract(year from current_datetime)=year(current_datetime),'ok','nok');
select if (extract(year from current_datetime())=year(current_datetime()),'ok','nok');
select if (extract(year from now())=year(now()),'ok','nok');
select if (extract(year from sysdatetime)=year(sysdatetime),'ok','nok');
select if (extract(year from sys_datetime)=year(sys_datetime),'ok','nok');




select if (extract(month from current_datetime)=month(current_datetime),'ok','nok');
select if (extract(month from current_datetime())=month(current_datetime()),'ok','nok');
select if (extract(month from now())=month(now()),'ok','nok');
select if (extract(month from sysdatetime)=month(sysdatetime),'ok','nok');
select if (extract(month from sys_datetime)=month(sys_datetime),'ok','nok');


select if (extract(day from current_datetime)=day(current_datetime),'ok','nok');
select if (extract(day from current_datetime())=day(current_datetime()),'ok','nok');
select if (extract(day from now())=day(now()),'ok','nok');
select if (extract(day from sysdatetime)=day(sysdatetime),'ok','nok');
select if (extract(day from sys_datetime)=day(sys_datetime),'ok','nok');



select if (extract(hour from current_datetime)=hour(current_datetime),'ok','nok');
select if (extract(hour from current_datetime())=hour(current_datetime()),'ok','nok');
select if (extract(hour from now())=hour(now()),'ok','nok');
select if (extract(hour from sysdatetime)=hour(sysdatetime),'ok','nok');
select if (extract(hour from sys_datetime)=hour(sys_datetime),'ok','nok');


set timezone '+08:00';
select if (extract(year from current_datetime)=year(current_datetime),'ok','nok');
select if (extract(year from current_datetime())=year(current_datetime()),'ok','nok');
select if (extract(year from now())=year(now()),'ok','nok');
select if (extract(year from sysdatetime)=year(sysdatetime),'ok','nok');
select if (extract(year from sys_datetime)=year(sys_datetime),'ok','nok');




select if (extract(month from current_datetime)=month(current_datetime),'ok','nok');
select if (extract(month from current_datetime())=month(current_datetime()),'ok','nok');
select if (extract(month from now())=month(now()),'ok','nok');
select if (extract(month from sysdatetime)=month(sysdatetime),'ok','nok');
select if (extract(month from sys_datetime)=month(sys_datetime),'ok','nok');


select if (extract(day from current_datetime)=day(current_datetime),'ok','nok');
select if (extract(day from current_datetime())=day(current_datetime()),'ok','nok');
select if (extract(day from now())=day(now()),'ok','nok');
select if (extract(day from sysdatetime)=day(sysdatetime),'ok','nok');
select if (extract(day from sys_datetime)=day(sys_datetime),'ok','nok');



select if (extract(hour from current_datetime)=hour(current_datetime),'ok','nok');
select if (extract(hour from current_datetime())=hour(current_datetime()),'ok','nok');
select if (extract(hour from now())=hour(now()),'ok','nok');
select if (extract(hour from sysdatetime)=hour(sysdatetime),'ok','nok');
select if (extract(hour from sys_datetime)=hour(sys_datetime),'ok','nok');

select if(extract(minute from current_datetime)=minute(current_datetime),'ok','nok');
select if(extract(minute from current_datetime())=minute(current_datetime()),'ok','nok');
select if(extract(minute from now())=minute(now()),'ok','nok');
select if(extract(minute from sysdatetime)=minute(sysdatetime),'ok','nok');
select if(extract(minute from sys_datetime)=minute(sys_datetime),'ok','nok');

select if(extract(second from current_datetime)=second(current_datetime),'ok','nok');
select if(extract(second from current_datetime())=second(current_datetime()),'ok','nok');
select if(extract(second from now())=second(now()),'ok','nok');
select if(extract(second from sysdatetime)=second(sysdatetime),'ok','nok');
select if(extract(second from sys_datetime)=second(sys_datetime),'ok','nok');

select if(extract(millisecond from current_datetime())=extract(millisecond from current_datetime),'ok','nok');
select if(extract(millisecond from now())=extract(millisecond from current_datetime()),'ok','nok');
select if(extract(millisecond from sys_datetime)=extract(millisecond from sysdatetime),'ok','nok');
set timezone 'Asia/Seoul';
