--+ holdcas on;
set timezone '+09:00';
set @x1=(select addtime(current_time,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_time,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_time,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_time,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_time(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_time(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_time(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_time(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;



set timezone '+09:00';
set @x1=(select addtime(curtime(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(curtime(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(curtime(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(curtime(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_date,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_date,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_date,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_date,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_date(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_date(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_date(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_date(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(curdate(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(curdate(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(curdate(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(curdate(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_datetime,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_datetime,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_datetime,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_datetime,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_datetime(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_datetime(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_datetime(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_datetime(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(now(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(now(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(now(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(now(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_timestamp,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_timestamp,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_timestamp,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_timestamp,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_timestamp(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_timestamp(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_timestamp(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_timestamp(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(localtimestamp,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtimestamp,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtimestamp,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtimestamp,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtimestamp(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtimestamp(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtimestamp(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtimestamp(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtime,timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtime,timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtime,timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtime,timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtime(),timestamptz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtime(),timestamptz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtime(),timestampltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtime(),timestampltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;



--+ holdcas off;
