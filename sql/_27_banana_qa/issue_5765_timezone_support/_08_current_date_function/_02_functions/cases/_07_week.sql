--+ holdcas on;
set timezone 'America/New_York';
select if(week(current_date)=week(current_date()) and week(current_date())=week(curdate()),'ok','nok');
set timezone 'Asia/Seoul';
select if(week(current_date)=week(current_date()) and week(current_date())=week(curdate()),'ok','nok');
set timezone '-12:00';
select if(week(current_date)=week(current_date()) and week(current_date())=week(curdate()),'ok','nok');
set timezone '+12:12';
select if(week(current_date)=week(current_date()) and week(current_date())=week(curdate()),'ok','nok');




set timezone 'America/New_York';
select if(week(current_datetime)=week(current_datetime()) and week(current_datetime())=week(now()),'ok','nok');
set timezone 'Asia/Seoul';
select if(week(current_datetime)=week(current_datetime()) and week(current_datetime())=week(now()),'ok','nok');
set timezone '-12:00';
select if(week(current_datetime)=week(current_datetime()) and week(current_datetime())=week(now()),'ok','nok');
set timezone '+12:12';
select if(week(current_datetime)=week(current_datetime()) and week(current_datetime())=week(now()),'ok','nok');





set timezone 'America/New_York';
select if(week(current_timestamp)=week(current_timestamp()) and week(current_timestamp())=week(localtime) and week(localtime)=week(localtimestamp) and week(localtimestamp)=week(localtimestamp()) and week(localtimestamp())=week(localtime()),'ok','nok');
set timezone 'Asia/Seoul';
select if(week(current_timestamp)=week(current_timestamp()) and week(current_timestamp())=week(localtime) and week(localtime)=week(localtimestamp) and week(localtimestamp)=week(localtimestamp()) and week(localtimestamp())=week(localtime()),'ok','nok');
set timezone '-12:00';
select if(week(current_timestamp)=week(current_timestamp()) and week(current_timestamp())=week(localtime) and week(localtime)=week(localtimestamp) and week(localtimestamp)=week(localtimestamp()) and week(localtimestamp())=week(localtime()),'ok','nok');
set timezone '+12:12';
select if(week(current_timestamp)=week(current_timestamp()) and week(current_timestamp())=week(localtime) and week(localtime)=week(localtimestamp) and week(localtimestamp)=week(localtimestamp()) and week(localtimestamp())=week(localtime()),'ok','nok');

set timezone 'Asia/Seoul';

--+ holdcas off;
