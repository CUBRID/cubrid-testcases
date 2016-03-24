--+ holdcas on;
set timezone '+9:00';
set @x1=(select new_time(now(),'Asia/Seoul','Asia/Shanghai'));
set @x2=(select new_time(now(),'Asia/Seoul','+06:00'));
select if(hour(@x1)-hour(@x2) in(2,-22),'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;

set timezone 'Pacific/Chatham';
set @x1=(select new_time(now(),'Pacific/Chatham','Asia/Shanghai'));
set @x2=(select new_time(now(),'Pacific/Chatham','+03:00'));
select if(hour(@x1)-hour(@x2) in(5,-19),'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;


set timezone 'Pacific/Tongatapu';
set @x1=(select now());
set timezone '+09:00';
set @x2=(select new_time(now(),'Asia/Seoul','Pacific/Tongatapu'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;

set timezone '+9:00';
set @x1=(select new_time(current_datetime(),'Asia/Seoul','Asia/Shanghai'));
set @x2=(select new_time(current_datetime(),'Asia/Seoul','+06:00'));
select if(hour(@x1)-hour(@x2) in(2,-22),'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;

set timezone 'Pacific/Chatham';
set @x1=(select new_time(current_datetime(),'Pacific/Chatham','Asia/Shanghai'));
set @x2=(select new_time(current_datetime(),'Pacific/Chatham','+03:00'));
select if(hour(@x1)-hour(@x2) in(5,-19),'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;


set timezone 'Pacific/Tongatapu';
set @x1=(select current_datetime());
set timezone '+09:00';
set @x2=(select new_time(current_datetime(),'Asia/Seoul','Pacific/Tongatapu'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;

set timezone '+9:00';
set @x1=(select new_time(current_time(),'Asia/Seoul','Asia/Shanghai'));
set @x2=(select new_time(current_time(),'Asia/Seoul','+06:00'));
select if(hour(@x1)-hour(@x2) in(2,-22),'ok','nok '||hour(@x1)-hour(@x2));

set timezone 'Pacific/Chatham';
set @x1=(select new_time(current_time(),'Pacific/Chatham','Asia/Shanghai'));
set @x2=(select new_time(current_time(),'Pacific/Chatham','+03:00'));
select if(hour(@x1)-hour(@x2) in(5,-19),'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;


set timezone 'Pacific/Tongatapu';
set @x1=(select current_time());
set timezone '+09:00';
set @x2=(select new_time(current_time(),'Asia/Seoul','Pacific/Tongatapu'));
select if(hour(@x1)-hour(@x2)=0,'ok','nok '||hour(@x1)-hour(@x2));
drop variable @x1,@x2;
set timezone 'Asia/Seoul';
--+ holdcas off;
