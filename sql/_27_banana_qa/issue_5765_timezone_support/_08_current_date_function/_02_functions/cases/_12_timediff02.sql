--+ holdcas on;
set timezone 'Asia/Seoul';
select timediff(current_timestamp,utc_timestamp());
select timediff(current_datetime,utc_timestamp());
select timediff(now(),utc_timestamp());
select timediff(localtimestamp(),utc_timestamp());
select timediff(localtime(),utc_timestamp());     
select timediff(localtime,utc_timestamp());                

set timezone '+03:00';
select timediff(current_timestamp,utc_timestamp());
select timediff(current_datetime,utc_timestamp());
select timediff(now(),utc_timestamp());
select timediff(localtimestamp(),utc_timestamp());
select timediff(localtime(),utc_timestamp());                                     
select timediff(localtime,utc_timestamp()); 



set timezone '+03:45';
select timediff(current_timestamp,utc_timestamp());
select timediff(current_datetime,utc_timestamp());
select timediff(now(),utc_timestamp());
select timediff(localtimestamp(),utc_timestamp());
select timediff(localtime(),utc_timestamp());                                     
select timediff(localtime,utc_timestamp()); 


set timezone '+03:00';
select if(datediff(current_timestamp,utc_date())=1 or datediff(current_timestamp,utc_date())=0,'ok','nok');
select if(datediff(current_datetime,utc_date())=1 or datediff(current_datetime,utc_date())=0,'ok','nok');
select if(datediff(now(),utc_date())=1 or datediff(now(),utc_date())=0,'ok','nok');
select if(datediff(localtimestamp(),utc_date())=1 or datediff(localtimestamp(),utc_date())=0,'ok','nok');
select if(datediff(localtime(),utc_date())=1 or datediff(localtime(),utc_date())=0,'ok','nok');
select if(datediff(localtime,utc_date())=1 or datediff(localtime,utc_date())=0,'ok','nok');


set timezone '-12:00';
select if(datediff(current_timestamp,utc_date())=-1 or datediff(current_timestamp,utc_date())=0,'ok','nok');
select if(datediff(current_datetime,utc_date())=-1 or datediff(current_datetime,utc_date())=0,'ok','nok');
select if(datediff(now(),utc_date())=-1 or datediff(now(),utc_date())=0,'ok','nok');
select if(datediff(localtimestamp(),utc_date())=-1 or datediff(localtimestamp(),utc_date())=0,'ok','nok');
select if(datediff(localtime(),utc_date())=-1 or datediff(localtime(),utc_date())=0,'ok','nok');
select if(datediff(localtime,utc_date())=-1 or datediff(localtime,utc_date())=0,'ok','nok');



set timezone '+03:15';
--select timediff(current_time,utc_time());
set @x1=(select(if(utc_time()-current_time>0,timediff(utc_time(),current_time), timediff(current_time,utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(current_timestamp),timediff(utc_time(),time(current_timestamp)),timediff(time(current_timestamp),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(current_datetime),timediff(utc_time(),time(current_datetime)),timediff(time(current_datetime),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(now()),timediff(utc_time(),time(now())),timediff(time(now()),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(localtimestamp),timediff(utc_time(),time(localtimestamp)),timediff(time(localtimestamp),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(localtimestamp()),timediff(utc_time(),time(localtimestamp())),timediff(time(localtimestamp()),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(localtime),timediff(utc_time(),time(localtime)),timediff(time(localtime),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;

set @x1=(select(if(utc_time()>time(localtime()),timediff(utc_time(),time(localtime())),timediff(time(localtime()),utc_time()))));
select if(time(@x1)=time('03:15:00 AM') or time(@x1)=time('20:45:00'),'ok','nok');
drop variable @x1;


set timezone '+03:15';
select timediff(timestamp(current_datetime),utc_timestamp());
--select timediff(timestamp(current_date),utc_timestamp());
select timediff(timestamp(current_timestamp),utc_timestamp());
select timediff(timestamp(now()),utc_timestamp());
select timediff(timestamp(localtimestamp()),utc_timestamp());
select timediff(timestamp(localtime()),utc_timestamp());
select timediff(timestamp(localtime),utc_timestamp());



--CUBRIDSUS-17374
--set timezone '-12:00';
set timezone '+02:00';
select timediff(timestamp(utc_timestamp()),utc_timestamp());
select timediff(timestamp(current_datetime),utc_timestamp());
--select timediff(timestamp(current_date),utc_timestamp());
--select timediff(timestamp(current_date),timestamp(current_timestamp));
select timediff(timestamp(current_date),timestamp(current_date));
select timediff(timestamp(current_datetime),timestamp(current_timestamp));
select timediff(current_timestamp,utc_timestamp());

set @x1=(select if(utc_time()>time(current_datetime),timediff(utc_time(),time(current_datetime)),timediff(time(current_datetime),utc_time())));
select if(time(@x1)=time('02:00:00') or time(@x1)=time('22:00:00'),'ok','nok');
drop variable @x1;


set @x1=(select datediff(current_datetime,utc_timestamp()));
select if (@x1=0 or @x1 =1,'ok','nok');
drop variable @x1;

set @x1=(select datediff(current_date,utc_timestamp()));
select if (@x1=0 or @x1 =1,'ok','nok');
drop variable @x1;

set @x1=(select datediff(current_date(),utc_timestamp()));
select if (@x1=0 or @x1 =1,'ok','nok');
drop variable @x1;

set @x1=(select datediff(current_date()+2,utc_timestamp()));
select if (@x1=2 or @x1 =3,'ok','nok');
drop variable @x1;



set timezone '+01:00';
select if(datediff(trunc(current_date,'dd'),utc_date())=1 or datediff(trunc(current_date,'dd'),utc_date())=0,'ok','nok');
select if(datediff(trunc(current_datetime,'dd'),utc_date())=1 or datediff(trunc(current_datetime,'dd'),utc_date())=0,'ok','nok');
select if(datediff(trunc(current_timestamp,'dd'),utc_date())=1 or datediff(trunc(current_timestamp,'dd'),utc_date())=0,'ok','nok');
select if(datediff(trunc(now(),'dd'),utc_date())=1 or datediff(trunc(now(),'dd'),utc_date())=0,'ok','nok');

set timezone 'Asia/Seoul';


--+ holdcas off;
