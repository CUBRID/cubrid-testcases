--+ holdcas on;
set timezone 'America/New_York';
select if(weekday(current_date)=weekday(current_date()) and weekday(current_date())=weekday(curdate()),'ok','nok');
set timezone 'Asia/Seoul';
select if(weekday(current_date)=weekday(current_date()) and weekday(current_date())=weekday(curdate()),'ok','nok');
set timezone '-12:00';
select if(weekday(current_date)=weekday(current_date()) and weekday(current_date())=weekday(curdate()),'ok','nok');
set timezone '+12:12';
select if(weekday(current_date)=weekday(current_date()) and weekday(current_date())=weekday(curdate()),'ok','nok');




set timezone 'America/New_York';
select if(weekday(current_datetime)=weekday(current_datetime()) and weekday(current_datetime())=weekday(now()),'ok','nok');
set timezone 'Asia/Seoul';
select if(weekday(current_datetime)=weekday(current_datetime()) and weekday(current_datetime())=weekday(now()),'ok','nok');
set timezone '-12:00';
select if(weekday(current_datetime)=weekday(current_datetime()) and weekday(current_datetime())=weekday(now()),'ok','nok');
set timezone '+12:12';
select if(weekday(current_datetime)=weekday(current_datetime()) and weekday(current_datetime())=weekday(now()),'ok','nok');





set timezone 'America/New_York';
select if(weekday(current_timestamp)=weekday(current_timestamp()) and weekday(current_timestamp())=weekday(localtime) and weekday(localtime)=weekday(localtimestamp) and weekday(localtimestamp)=weekday(localtimestamp()) and weekday(localtimestamp())=weekday(localtime()),'ok','nok');
set timezone 'Asia/Seoul';
select if(weekday(current_timestamp)=weekday(current_timestamp()) and weekday(current_timestamp())=weekday(localtime) and weekday(localtime)=weekday(localtimestamp) and weekday(localtimestamp)=weekday(localtimestamp()) and weekday(localtimestamp())=weekday(localtime()),'ok','nok');
set timezone '-12:00';
select if(weekday(current_timestamp)=weekday(current_timestamp()) and weekday(current_timestamp())=weekday(localtime) and weekday(localtime)=weekday(localtimestamp) and weekday(localtimestamp)=weekday(localtimestamp()) and weekday(localtimestamp())=weekday(localtime()),'ok','nok');
set timezone '+12:12';
select if(weekday(current_timestamp)=weekday(current_timestamp()) and weekday(current_timestamp())=weekday(localtime) and weekday(localtime)=weekday(localtimestamp) and weekday(localtimestamp)=weekday(localtimestamp()) and weekday(localtimestamp())=weekday(localtime()),'ok','nok');

set timezone 'Asia/Seoul';

--+ holdcas off;
