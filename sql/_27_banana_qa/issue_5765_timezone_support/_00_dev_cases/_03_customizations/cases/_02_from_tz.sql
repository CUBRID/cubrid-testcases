select from_tz(datetime '10/10/2014 00:00:00 AM', 'Europe/Vienna');
select from_tz(datetime '09/12/2000 09:00:0 AM', 'Europe/London');
select from_tz(datetime '03/10/2014 12:12:12 PM', 'Europe/Moscow');
select from_tz(datetime '03/10/2014 23:59:59 PM', 'Europe/Zurich');
select from_tz(datetime '10/10/2014 23:59:59 PM', 'America/New_York');
select from_tz(datetime '10/10/2014 00:00:00 AM', '+00:00');
select from_tz(datetime '10/10/2014 23:59:59 PM', '+03:25:25');
select from_tz(datetime '10/10/9999 23:59:59 PM', '+03:00');
select from_tz(datetime '10/10/2014 23:59:59 AM', '+00:00');
select from_tz(datetime '10/10/2014 10:10:10', 'Europe/Viennaa');
select from_tz(datetime '10/10/2014 10:10:10', 'Europe/Bucharest5');

select from_tz(time '23:59:59 PM', 'Asia/Seoul');
select from_tz(time '00:00:00 AM','Asia/Bahrain');
select from_tz(time '23:59:10 PM', 'Africa/Douala');
select from_tz(time '23:59:59 PM', '+23:00');
select from_tz(time '10/10/2014 10:10:10', 'Europe/Bucharest5');
select from_tz(time '10/10/2014 10:10:10', 'Europe/Viennaa');

drop table if exists test;
create table test (a int , b datetime, c string);
insert into test values(1, datetime '10/10/2014 00:00:00 AM', 'Europe/Vienna');
insert into test values(2, datetime '09/12/2000 09:00:0 AM', 'Europe/London');
insert into test values(3, datetime '03/10/2014 12:12:12 PM', 'Europe/Moscow');
insert into test values(4, datetime '03/10/2014 23:59:59 PM', 'Europe/Zurich');
insert into test values(5, datetime '03/10/2014 23:59:59 PM', '+13:00');
select from_tz(a,c) from test;
select from_tz(b,c) from test order by 1;

drop table if exists test2;
create table test2(a int , b time, c string);
insert into test2 values(1, time '23:59:59 PM', 'Asia/Seoul');
insert into test2 values(2, time '00:00:00 AM','Asia/Bahrain');
insert into test2 values(3, time '23:59:10 PM', 'Africa/Douala');
insert into test2 values(4, time '23:59:59 PM', '+13:00');
select from_tz(a,c) from test2;
select from_tz(b,c) from test2;

drop test;
drop test2;

