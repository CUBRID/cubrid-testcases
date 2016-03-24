--+ holdcas on;
--CUBRIDSUS-17423 resolved,need to change answer
set timezone '+09:00';
set @x1=(select unix_timestamp());
set timezone '+08:00';
set @x2=(select unix_timestamp());
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select unix_timestamp(current_datetime));
set timezone '+08:00';
set @x2=(select unix_timestamp(current_datetime));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select unix_timestamp(sysdatetime));
set timezone '+08:00';
set @x2=(select unix_timestamp(sysdatetime));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select unix_timestamp(current_timestamp));
set timezone '+08:00';
set @x2=(select unix_timestamp(current_timestamp));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select unix_timestamp(localtimestamp));
set timezone '+08:00';
set @x2=(select unix_timestamp(localtimestamp));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select unix_timestamp(systimestamp));
set timezone '+08:00';
set @x2=(select unix_timestamp(systimestamp));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select unix_timestamp(current_date));
set timezone '+08:00';
set @x2=(select unix_timestamp(current_date));
select if(abs(@x2 -@x1)>=3600,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select unix_timestamp(sysdate));
set timezone '+08:00';
set @x2=(select unix_timestamp(sysdate));
select if(abs(@x2 -@x1)>=3600,'nok','ok');
drop variable @x1,@x2;

set timezone 'Asia/Seoul';                                         
--+ holdcas off;
