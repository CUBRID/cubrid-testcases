--alter session timezone, the sessiontimezone result should be changed.

set timezone '-2:00';
select tz_offset(sessiontimezone);

set timezone '+7:00';
select tz_offset(sessiontimezone);

set timezone 'Asia/Bahrain';
select tz_offset(sessiontimezone);

set timezone 'Africa/Kampala';
select tz_offset(sessiontimezone);

set timezone 'America/Argentina/Rio_Gallegos';
select tz_offset(sessiontimezone);


set timezone 'Asia/Seoul';
select tz_offset(sessiontimezone);
