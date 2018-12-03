--+ holdcas on;
set timezone '+04:00';
set @x1=(select current_datetime);
set timezone '+08:00';
set @x2=(select current_datetime);
set @x3=(select adddate(current_datetime,interval 2 month));
set @x4=(select adddate(current_datetime,interval 2 hour));
select if (datediff(@x2,@x1) in(0,1), 'ok', 'nok');
select if (month(@x3)-month(@x1) in (2,3,-9,-10), 'ok', 'nok');
select if (hour(@x4)-hour(@x1) in (6, -18), 'ok', 'nok');
drop variable @x1,@x2,@x3,@x4;


set timezone '+04:00';
set @x1=(select current_datetime);
set timezone '+08:00';
set @x2=(select current_datetime);
select if((timediff(@x2,@x1) >= time'04:00:00' and timediff(@x2,@x1) <= time'04:02:00'), 'ok', 'nok');
drop variable @x1,@x2;

set timezone '+04:00';
set @x1=(select current_timestamp);
set timezone '+08:00';
set @x2=(select current_timestamp);
set @x3=(select adddate(current_timestamp,interval 2 month));
set @x4=(select adddate(current_timestamp,interval 2 hour));
select if (datediff(@x2,@x1) in(0,1), 'ok', 'nok');
select if (month(@x3)-month(@x1) in (2,3,-9,-10,-11), 'ok', 'nok');
select if (hour(@x4)-hour(@x1) in (6, -18), 'ok', 'nok');
drop variable @x1,@x2,@x3,@x4;

set timezone '+04:00';
set @x1=(select current_date);
set timezone '+08:00';
set @x2=(select current_date);
set @x3=(select adddate(current_date,interval 2 month));
set @x4=(select adddate(current_date,interval 2 hour));
select if (datediff(@x2,@x1) in(0,1), 'ok', 'nok');
select if (month(@x3)-month(@x1) in (2,3,-9,-10), 'ok', 'nok');
select if (hour(@x4)-hour(@x1) in (6, -18), 'ok', 'nok');
drop variable @x1,@x2,@x3,@x4;

set timezone 'Asia/Seoul';
--+ holdcas off;
