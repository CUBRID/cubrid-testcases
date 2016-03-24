--+ holdcas on;
set timezone 'America/New_York';
select if(year(current_date)=year(current_date()) and year(current_date())=year(curdate()),'ok','nok');
set timezone 'Asia/Seoul';
select if(year(current_date)=year(current_date()) and year(current_date())=year(curdate()),'ok','nok');
set timezone '-12:00';
select if(year(current_date)=year(current_date()) and year(current_date())=year(curdate()),'ok','nok');
set timezone '+12:12';
select if(year(current_date)=year(current_date()) and year(current_date())=year(curdate()),'ok','nok');




set timezone 'America/New_York';
select if(year(current_datetime)=year(current_datetime()) and year(current_datetime())=year(now()),'ok','nok');
set timezone 'Asia/Seoul';
select if(year(current_datetime)=year(current_datetime()) and year(current_datetime())=year(now()),'ok','nok');
set timezone '-12:00';
select if(year(current_datetime)=year(current_datetime()) and year(current_datetime())=year(now()),'ok','nok');
set timezone '+12:12';
select if(year(current_datetime)=year(current_datetime()) and year(current_datetime())=year(now()),'ok','nok');





set timezone 'America/New_York';
select if(year(current_timestamp)=year(current_timestamp()) and year(current_timestamp())=year(localtime) and year(localtime)=year(localtimestamp) and year(localtimestamp)=year(localtimestamp()) and year(localtimestamp())=year(localtime()),'ok','nok');
set timezone 'Asia/Seoul';
select if(year(current_timestamp)=year(current_timestamp()) and year(current_timestamp())=year(localtime) and year(localtime)=year(localtimestamp) and year(localtimestamp)=year(localtimestamp()) and year(localtimestamp())=year(localtime()),'ok','nok');
set timezone '-12:00';
select if(year(current_timestamp)=year(current_timestamp()) and year(current_timestamp())=year(localtime) and year(localtime)=year(localtimestamp) and year(localtimestamp)=year(localtimestamp()) and year(localtimestamp())=year(localtime()),'ok','nok');
set timezone '+12:12';
select if(year(current_timestamp)=year(current_timestamp()) and year(current_timestamp())=year(localtime) and year(localtime)=year(localtimestamp) and year(localtimestamp)=year(localtimestamp()) and year(localtimestamp())=year(localtime()),'ok','nok');

set timezone 'Asia/Seoul';

--+ holdcas off;
