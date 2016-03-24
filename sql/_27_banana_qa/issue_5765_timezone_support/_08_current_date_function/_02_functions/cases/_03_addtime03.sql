--+ holdcas on;
set timezone '+09:00';
set @x1=(select addtime(current_time,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_time,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_time,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_time,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_time(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_time(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_time(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_time(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;



set timezone '+09:00';
set @x1=(select addtime(curtime(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(curtime(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(curtime(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(curtime(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_date,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_date,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_date,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_date,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_date(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_date(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_date(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_date(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(curdate(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(curdate(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(curdate(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(curdate(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_datetime,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_datetime,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_datetime,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_datetime,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(current_datetime(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_datetime(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_datetime(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_datetime(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(now(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(now(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(now(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(now(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_timestamp,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_timestamp,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_timestamp,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_timestamp,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(current_timestamp(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(current_timestamp(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(current_timestamp(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(current_timestamp(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set timezone '+09:00';
set @x1=(select addtime(localtimestamp,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtimestamp,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtimestamp,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtimestamp,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtimestamp(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtimestamp(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtimestamp(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtimestamp(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtime,datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtime,datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtime,datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtime,datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+09:00';
set @x1=(select addtime(localtime(),datetimetz'2000-8-24 00:00:00 +11:00'));
set @x2=(select addtime(localtime(),datetimetz'2000-8-24 00:00:00 +10:00'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok');
drop variable @x1,@x2;
set @x1=(select addtime(localtime(),datetimeltz'2000-8-24 02:00:00 +11:00'));
set @x2=(select addtime(localtime(),datetimeltz'2000-8-24 01:00:00 +10:00'));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;



--+ holdcas off;
