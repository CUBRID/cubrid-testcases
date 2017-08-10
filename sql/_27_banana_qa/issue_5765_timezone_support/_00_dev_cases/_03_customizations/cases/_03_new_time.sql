select new_time(datetime '10/10/2014 10:10:10 AM', 'Europe/Vienna', 'Europe/Bucharest');
select new_time(datetime '10/10/2014 10:10:10 AM', 'Europe/Vienna', 'Europe/Vienna');
select new_time(datetime '10/10/2014 10:10:10 AM', 'Europe/Vienna', 'Europe/London');
select new_time(datetime '03/10/2014 10:10:10 PM', 'Europe/Moscow', 'Europe/Zurich');
select new_time(datetime '03/10/2014 23:59:59 PM', 'Europe/Paris', 'Asia/Seoul');
select new_time(datetime '10/10/2014 23:59:59 PM', 'Europe/Paris', 'America/New_York');
select new_time(datetime '10/10/2014 10:10:10 PM', '+04:00', '+04:00');
select new_time(datetime '10/10/2014 10:10:10', 'Europe/Vienna', 'Europe/Bucharest');
select new_time(datetime '10/10/2014 10:10:10', 'Europe/Viennaa', 'Europe/Bucharest');
select new_time(datetime '10/10/2014 10:10:10', 'Europe/Vienna', 'Europe/Bucharest5');
select new_time(datetime '10/10/2014 10:10:10 PM', 'Europe/Paris', '+04:00');
select new_time(time '10:10:10 PM', 'Asia/Seoul', 'Asia/Bahrain');
select new_time(time '23:59:10 PM', 'Asia/Bahrain', 'Africa/Douala');

create table test (a int , b datetime, c string, d string);
insert into test values(1,  datetime '03/10/2014 23:59:59 PM', 'Europe/Paris', 'Asia/Seoul');
insert into test values(2,  datetime '10/10/2014 23:59:59 PM', 'Europe/Paris', 'America/New_York');
insert into test values(3,  datetime '03/10/2014 10:10:10 PM', 'Asia/Seoul', 'Asia/Bahrain');
insert into test values(4,  datetime '03/10/2014 10:10:10 PM', 'Europe/Moscow', 'Europe/Zurich');
insert into test values(5,  datetime '10/10/2014 23:59:59', 'Asia/Bahrain', 'Africa/Douala');
select new_time(a,c,d) from test order by 1;
select new_time(b,c,d) from test order by 1;

create table test2 (a int , b time, c string, d string);
insert into test2 values(1,  time '10:10:10 PM', 'Asia/Seoul', 'Asia/Bahrain');
insert into test2 values(2,  time '23:59:10 PM', 'Asia/Bahrain', 'Africa/Douala');
select new_time(a,c,d) from test2 order by 1;
select new_time(b,c,d) from test2 order by 1;

drop test;
drop test2;
