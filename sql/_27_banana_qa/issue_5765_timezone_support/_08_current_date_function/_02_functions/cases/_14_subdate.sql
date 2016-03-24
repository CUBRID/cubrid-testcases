--+ holdcas on;
set timezone '+02:00';
select if(day(current_date)-day(subdate(current_date,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');
select if(day(current_datetime)-day(subdate(current_datetime,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');
select if(day(current_timestamp)-day(subdate(current_timestamp,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');


set timezone '-02:00';
select if(day(current_date)-day(subdate(current_date,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');
select if(day(current_datetime)-day(subdate(current_datetime,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');
select if(day(current_timestamp)-day(subdate(current_timestamp,interval 24 hour)) in (1,-27,-28,-29,-30),'ok','nok');
set timezone 'Asia/Seoul';
--+ holdcas off;
