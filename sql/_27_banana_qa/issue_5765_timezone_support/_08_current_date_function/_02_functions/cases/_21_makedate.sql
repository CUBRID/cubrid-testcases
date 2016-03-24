--+ holdcas on;

set timezone '+09:00';
set @x1=(select year(current_datetime));
set @x3=(select dayofyear(current_datetime));

set timezone '+10:00';
set @y3=(select dayofyear(current_datetime));

select if((@y3>@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=1) or (@y3=@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=0),'ok','nok');
drop variable @x1,@x3,@y3;


set timezone '+09:00';
set @x1=(select year(current_date));
set @x3=(select dayofyear(current_date));

set timezone '+10:00';
set @y3=(select dayofyear(current_date));

select if((@y3>@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=1) or (@y3=@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=0),'ok','nok');
drop variable @x1,@x3,@y3;


set timezone '+09:00';
set @x1=(select year(current_timestamp));
set @x3=(select dayofyear(current_timestamp));

set timezone '+10:00';
set @y3=(select dayofyear(current_timestamp));

select if((@y3>@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=1) or (@y3=@x3 and makedate(@x1,@y3)-makedate(@x1,@x3)=0),'ok','nok');
drop variable @x1,@x3,@y3;
set timezone 'Asia/Seoul';
--+ holdcas off;
