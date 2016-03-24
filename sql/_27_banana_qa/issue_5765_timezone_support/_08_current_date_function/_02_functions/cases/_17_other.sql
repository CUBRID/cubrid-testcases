--+ holdcas on;
set timezone '-2:00';
set @a1=(select dayofweek(current_datetime));
set @b1=(select dayofyear(current_datetime));
set @c1=(select dayofmonth(current_datetime));

set timezone '+3:00';
set @a2=(select dayofweek(current_datetime));
set @b2=(select dayofyear(current_datetime));
set @c2=(select dayofmonth(current_datetime));
--expect 0 or 1
select if(@a2-@a1 in (0,1,-6),'ok','nok '|| now()||@a2-@a1);
select if(@b2-@b1=0 or @b2-@b1=1,'ok','nok '|| now()||@b2-@b1);
select if(@c2-@c1 in (0,1,-27,-28,-29,-30),'ok','nok '||@c2-@c1);
drop variable @a1,@a2,@b1,@b2,@c2,@c1;
set timezone 'Asia/Seoul';
--+ holdcas off;
