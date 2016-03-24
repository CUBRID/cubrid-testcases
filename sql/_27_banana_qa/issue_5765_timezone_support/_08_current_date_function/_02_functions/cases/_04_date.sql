--+ holdcas on;
set timezone 'America/New_York';
select if(date(current_date)=date(current_date()) and date(current_date())=date(curdate()),'ok','nok');
set timezone 'Asia/Seoul';
select if(date(current_date)=date(current_date()) and date(current_date())=date(curdate()),'ok','nok');
set timezone '-12:00';
select if(date(current_date)=date(current_date()) and date(current_date())=date(curdate()),'ok','nok');
set timezone '+12:12';
select if(date(current_date)=date(current_date()) and date(current_date())=date(curdate()),'ok','nok');




set timezone 'America/New_York';
select if(date(current_datetime)=date(current_datetime()) and date(current_datetime())=date(now()),'ok','nok');
set timezone 'Asia/Seoul';
select if(date(current_datetime)=date(current_datetime()) and date(current_datetime())=date(now()),'ok','nok');
set timezone '-12:00';
select if(date(current_datetime)=date(current_datetime()) and date(current_datetime())=date(now()),'ok','nok');
set timezone '+12:12';
select if(date(current_datetime)=date(current_datetime()) and date(current_datetime())=date(now()),'ok','nok');





set timezone 'America/New_York';
select if(date(current_timestamp)=date(current_timestamp()) and date(current_timestamp())=date(localtime) and date(localtime)=date(localtimestamp) and date(localtimestamp)=date(localtimestamp()) and date(localtimestamp())=date(localtime()),'ok','nok');
set timezone 'Asia/Seoul';
select if(date(current_timestamp)=date(current_timestamp()) and date(current_timestamp())=date(localtime) and date(localtime)=date(localtimestamp) and date(localtimestamp)=date(localtimestamp()) and date(localtimestamp())=date(localtime()),'ok','nok');
set timezone '-12:00';
select if(date(current_timestamp)=date(current_timestamp()) and date(current_timestamp())=date(localtime) and date(localtime)=date(localtimestamp) and date(localtimestamp)=date(localtimestamp()) and date(localtimestamp())=date(localtime()),'ok','nok');
set timezone '+12:12';
select if(date(current_timestamp)=date(current_timestamp()) and date(current_timestamp())=date(localtime) and date(localtime)=date(localtimestamp) and date(localtimestamp)=date(localtimestamp()) and date(localtimestamp())=date(localtime()),'ok','nok');

set timezone 'Asia/Seoul';

--+ holdcas off;
