--+ holdcas on;
--select timediff(timestamp('2015-8-6',sec_to_time(82800)),timestamp('2015-8-5',sec_to_time(81000))): print error
set timezone '+02:00';
set @x1=(select if(datediff(current_date,utc_date())=0,timediff(timestamp(current_date,sec_to_time(82800)),timestamp(utc_date(),sec_to_time(81000))),timediff(timestamp(current_date,sec_to_time(81000)),timestamp(utc_date(),sec_to_time(82800)))));
select if (time(@x1)=time('00:30:00') or time(@x1)=time('11:30:00 pm'),'ok','nok');
drop variable @x1;
select timediff(timestamp(current_datetime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));    
select timediff(timestamp(current_timestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));    
select timediff(timestamp(current_datetime(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(current_timestamp(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
set timezone '+01:00';
select timediff(timestamp(now(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));

set timezone 'Asia/Seoul';
select timediff(timestamp(now(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));

set timezone 'Asia/Shanghai';
select timediff(timestamp(now(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtimestamp(),sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(localtime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));


set timezone 'Asia/Shanghai';
select timediff(timestamp(systimestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(sys_timestamp,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(sysdatetime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));
select timediff(timestamp(sys_datetime,sec_to_time(82800)),timestamp(utc_timestamp(),sec_to_time(81000)));

set timezone 'Asia/Seoul';
--+ holdcas off;
