--+ holdcas on;
set timezone 'America/New_York';
set @x1=(select now());
set @x2=(select from_unixtime(unix_timestamp(now())));
select if(hour(@x2)-hour(@x1)=0,'ok','nok'); 
drop variable @x1,@x2;


set @x1=(select current_datetime);
set @x2=(select from_unixtime(unix_timestamp(current_datetime)));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set @x1=(select current_timestamp());
set @x2=(select from_unixtime(unix_timestamp(current_timestamp())));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set @x1=(select current_datetime());
set @x2=(select from_unixtime(unix_timestamp(current_datetime())));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;




set @x1=(select current_timestamp);
set @x2=(select from_unixtime(unix_timestamp(current_timestamp)));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set @x1=(select localtime);
set @x2=(select from_unixtime(unix_timestamp(localtime)));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set @x1=(select localtime());
set @x2=(select from_unixtime(unix_timestamp(localtime())));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;



set @x1=(select localtimestamp());
set @x2=(select from_unixtime(unix_timestamp(localtimestamp())));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;


set @x1=(select localtimestamp);
set @x2=(select from_unixtime(unix_timestamp(localtimestamp)));
select if(hour(@x2)-hour(@x1)=0,'ok','nok');
drop variable @x1,@x2;

set timezone 'Asia/Seoul';

--need to think of summer time
--set timezone 'America/New_York';
--select from_unixtime(1437642174,'%y%m%d %H%i%S');
--+ holdcas off;
