--+ holdcas on;
set timezone '+08:00';
set @x1=(select addtime(current_date,datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date,datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_date,datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date,datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(current_date(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date(),datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_date(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(curdate(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(curdate(),datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(curdate(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(curdate(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_datetime,datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_datetime,datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_datetime,datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_datetime,datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(current_datetime(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_datetime(),datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_datetime(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_datetime(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(now(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(now(),datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(now(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(now(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_timestamp,datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp,datetimetz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_timestamp,datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_timestamp,datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_timestamp(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp(),datetimetz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_timestamp(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_timestamp(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(localtimestamp,datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtimestamp,datetimetz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtimestamp,datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtimestamp,datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtimestamp(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtimestamp(),datetimetz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtimestamp(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtimestamp(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtime,datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtime,datetimetz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtime,datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtime,datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtime(),datetimetz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtime(),datetimetz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1,2,-23,-22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtime(),datetimeltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtime(),datetimeltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2,3,-22,-21),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Seoul';

--+ holdcas off;
