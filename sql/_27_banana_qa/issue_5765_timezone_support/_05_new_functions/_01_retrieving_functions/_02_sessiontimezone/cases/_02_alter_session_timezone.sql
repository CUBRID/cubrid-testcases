--alter session timezone, the sessiontimezone result should be changed.

set timezone '-2:00';
select sessiontimezone();

set timezone '+7:00';
select sessiontimezone();

set timezone '-11:59';
select sessiontimezone();

set timezone 'Asia/Bahrain';
select sessiontimezone();

set timezone 'Europe/Luxembourg';
select sessiontimezone();
select sessiontimezone();

set timezone 'America/Argentina/San_Luis';
select sessiontimezone();

set time zone 'Antarctica/DumontDUrville';
select sessiontimezone();

set time zone 'Indian/Mayotte';
select sessiontimezone();
select sessiontimezone();

set time zone '123';
select sessiontimezone();

set timezone 'America/Los_Angeles';
select sessiontimezone();

set timezone 'Asia/Seoul';
