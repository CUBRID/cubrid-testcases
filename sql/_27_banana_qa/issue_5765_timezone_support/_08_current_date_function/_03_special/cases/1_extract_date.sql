set timezone 'America/New_York';
select if(extract(year from current_date)=year(current_date),'ok','nok');
select if(extract(year from current_date())=year(current_date()),'ok','nok');
select if(extract(year from curdate())=year(curdate()),'ok','nok');
select if(extract(year from sys_date)=year(sys_date),'ok','nok');
select if(extract(year from sysdate)=year(sysdate),'ok','nok');


select if(extract(month from current_date)=month(current_date),'ok','nok');
select if(extract(month from current_date())=month(current_date()),'ok','nok');
select if(extract(month from curdate())=month(curdate()),'ok','nok');
select if(extract(month from sysdate)=month(sysdate),'ok','nok');
select if(extract(month from sys_date)=month(sys_date),'ok','nok');


select if(extract(day from current_date)=day(current_date),'ok','nok');
select if(extract(day from current_date())=day(current_date()),'ok','nok');
select if(extract(day from curdate())=day(curdate()),'ok','nok');
select if(extract(day from sysdate)=day(sysdate),'ok','nok');
select if(extract(day from sys_date)=day(sys_date),'ok','nok');


select if(extract(hour from current_date)=hour(current_date),'ok','nok');
select if(extract(hour from current_date())=hour(current_date()),'ok','nok');
select if(extract(hour from curdate())=hour(curdate()),'ok','nok');
select if(extract(hour from sysdate)=hour(sysdate),'ok','nok');
select if(extract(hour from sys_date)=hour(sys_date),'ok','nok');


set timezone '+08:00';
select if(extract(year from current_date)=year(current_date),'ok','nok');
select if(extract(year from current_date())=year(current_date()),'ok','nok');
select if(extract(year from curdate())=year(curdate()),'ok','nok');
select if(extract(year from sysdate)=year(sysdate),'ok','nok');
select if(extract(year from sys_date)=year(sys_date),'ok','nok');


select if(extract(month from current_date)=month(current_date),'ok','nok');
select if(extract(month from current_date())=month(current_date()),'ok','nok');
select if(extract(month from curdate())=month(curdate()),'ok','nok');
select if(extract(month from sysdate)=month(sysdate),'ok','nok');
select if(extract(month from sys_date)=month(sys_date),'ok','nok');


select if(extract(day from current_date)=day(current_date),'ok','nok');
select if(extract(day from current_date())=day(current_date()),'ok','nok');
select if(extract(day from curdate())=day(curdate()),'ok','nok');
select if(extract(day from sysdate)=day(sysdate),'ok','nok');
select if(extract(day from sys_date)=day(sys_date),'ok','nok');


select if(extract(hour from current_date)=hour(current_date),'ok','nok');
select if(extract(hour from current_date())=hour(current_date()),'ok','nok');
select if(extract(hour from curdate())=hour(curdate()),'ok','nok');
select if(extract(hour from sysdate)=hour(sysdate),'ok','nok');
select if(extract(hour from sys_date)=hour(sys_date),'ok','nok');

set timezone 'Asia/Seoul';
