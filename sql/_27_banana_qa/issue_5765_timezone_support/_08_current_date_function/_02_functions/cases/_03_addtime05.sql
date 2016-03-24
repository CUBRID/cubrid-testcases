--+ holdcas on;
set timezone '+08:00';
set @x1=(select addtime(current_date,timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date,timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_date,timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date,timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(current_date(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date(),timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_date(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_date(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(curdate(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(curdate(),timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (0,1,-23),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(curdate(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(curdate(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_timestamp,timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp,timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone '+08:00';
set @x1=(select addtime(current_timestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(current_timestamp(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp(),timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_timestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_timestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(now(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(now(),timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(now(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(now(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_timestamp,timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp,timestamptz'2000-8-24 3:00:00 +011:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_timestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_timestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(current_timestamp(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(current_timestamp(),timestamptz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(current_timestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(current_timestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;


set timezone '+08:00';
set @x1=(select addtime(localtimestamp,timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtimestamp,timestamptz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtimestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtimestamp,timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtimestamp(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtimestamp(),timestamptz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtimestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtimestamp(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtime,timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtime,timestamptz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtime,timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtime,timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;

set timezone '+08:00';
set @x1=(select addtime(localtime(),timestamptz'2000-8-24 3:00:00 +010:00'));
set timezone '+09:00';
set @x2=(select addtime(localtime(),timestamptz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (1, 2, -23, -22),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Shanghai';
set @x1=(select addtime(localtime(),timestampltz'2000-8-24 3:00:00 +010:00'));
set timezone 'Asia/Seoul';
set @x2=(select addtime(localtime(),timestampltz'2000-8-24 3:00:00 +010:00'));
select if(hour(@x2)-hour(@x1) in (2, 3, -22, -21),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Seoul';

--+ holdcas off;
