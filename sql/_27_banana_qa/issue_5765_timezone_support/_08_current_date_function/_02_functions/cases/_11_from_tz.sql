--+ holdcas on;
--CUBRIDSUS-17448 have resolved ,need to modify cases and answers
set timezone '+02:00';
select from_tz(now(),'+02:00')-now();
select from_tz(now(),'+03:00')-now();


set timezone '+08:00';
select from_tz(now(),'Asia/Seoul')-now();
select from_tz(now(),'+03:00')-now(); 




set timezone '+02:00';
select from_tz(current_date(),'+02:00')-current_date();
select from_tz(current_date(),'+03:00')-current_date();
 
 
set timezone '+08:00';
select from_tz(current_date(),'Asia/Seoul')-current_date();
select from_tz(current_date(),'+03:00')-current_date();




set timezone '+02:00';
select from_tz(current_datetime(),'+02:00')-current_datetime();
select from_tz(current_datetime(),'+03:00')-current_datetime();
 
 
set timezone '+08:00';
select from_tz(current_datetime(),'Asia/Seoul')-current_datetime();
select from_tz(current_datetime(),'+03:00')-current_datetime();



--CUBRIDSUS-17448
set timezone '+02:00';
select from_tz(current_time(),'+02:00')-current_time();
select from_tz(current_time(),'+03:00')-current_time();
set timezone '+08:00';
select from_tz(current_time(),'Asia/Seoul')-current_time();
select from_tz(current_time(),'+03:00')-current_time();



set timezone '+02:00';
select from_tz(current_timestamp(),'+02:00')-current_timestamp();
select from_tz(current_timestamp(),'+03:00')-current_timestamp();


set timezone '+08:00';
select from_tz(current_timestamp(),'Asia/Seoul')-current_timestamp();
select from_tz(current_timestamp(),'+03:00')-current_timestamp();

set timezone 'Asia/Seoul';

--+ holdcas off;
