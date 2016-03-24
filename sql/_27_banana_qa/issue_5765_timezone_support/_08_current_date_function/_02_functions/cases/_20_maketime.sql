--+ holdcas on;
set timezone '+09:00';
set @x1=(select hour(current_time));
set @x2=(select minute(current_time));
set @x3=(select second(current_time));

set timezone '+10:00';
set @y1=(select hour(current_time));

select if((@y1>@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=3600) or (@y1<@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=-82800),'ok','nok');
drop variable @x1,@x2,@x3,@y1;


set timezone '+09:00';
set @x1=(select hour(current_datetime));
set @x2=(select minute(current_datetime));
set @x3=(select second(current_datetime));

set timezone '+10:00';
set @y1=(select hour(current_datetime));

select if((@y1>@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=3600) or (@y1<@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=-82800),'ok','nok');
drop variable @x1,@x2,@x3,@y1;



set timezone '+09:00';
set @x1=(select hour(current_timestamp));
set @x2=(select minute(current_timestamp));
set @x3=(select second(current_timestamp));

set timezone '+10:00';
set @y1=(select hour(current_timestamp));

select if((@y1>@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=3600) or (@y1<@x1 and maketime(@y1,@x2,@x3)-maketime(@x1,@x2,@x3)=-82800),'ok','nok');
drop variable @x1,@x2,@x3,@y1;
set timezone 'Asia/Seoul';
--+ holdcas off;
