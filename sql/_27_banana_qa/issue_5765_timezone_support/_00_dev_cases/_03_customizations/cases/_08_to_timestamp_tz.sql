select to_timestamp_tz('2/12/2012 23:59:59');
select to_timestamp_tz('08-Dec-25 13:10:30 Europe/Vienna CET', 'YY-Mon-DD HH24:MI:SS TZR TZD');
select to_timestamp_tz('08-Dec-25 13:10:30 Europe/Vienna CEST', 'YY-Mon-DD HH24:MI:SS TZR TZD');
select to_timestamp_tz('08-Dec-25 Europe/Vienna CET', 'YY-Mon-DD TZR TZD');
select to_timestamp_tz('08-Dec-25 13:10:30 Europe/Vienna CEST +13', 'YY-Mon-DD HH24:MI:SS TZR TZD TZH');
select to_timestamp_tz('08-Dec-25 13:10:30 +13', 'YY-Mon-DD HH24:MI:SS TZH');
select to_timestamp_tz('08-Dec-25 13:10:30 +13', 'YY-Mon-DD HH24:MI:SS TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 -11', 'YY-Mon-DD HH24:MI:SS TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 23', 'YY-Mon-DD HH24:MI:SS TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 +13 14', 'YY-Mon-DD HH24:MI:SS TZH TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 +13 +14', 'YY-Mon-DD HH24:MI:SS TZH TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 +13 -14', 'YY-Mon-DD HH24:MI:SS TZH TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 -11 14', 'YY-Mon-DD HH24:MI:SS TZH TZM');
select to_timestamp_tz('08-Dec-25 13:10:30 CET', 'YY-Mon-DD HH24:MI:SS TZD');
select to_timestamp_tz('08-Dec-25 13:10:30 Asia/Seoul', 'YY-Mon-DD HH24:MI:SS TZR');
select to_timestamp_tz('12-12-02 Europe/Zurich 13:10:30 CET', 'YY-MM-DD TZR HH24:MI:SS TZD');
select to_timestamp_tz('14-09-25 CET 13:10:30 Europe/Vienna', 'YY-MM-DD TZD HH24:MI:SS TZR');
select to_timestamp_tz('14-09-25 +13 13:10:30 14', 'YY-MM-DD TZH HH24:MI:SS TZM');
select to_timestamp_tz('14-09-25 14 13:10:30 -11', 'YY-MM-DD TZM HH24:MI:SS TZH');

drop table if exists test;
create table test (a int , b string);
insert into test values(1, '12-12-02 Europe/Paris 13:10:30 CET');
insert into test values(2, '08-09-25 America/New_York 13:10:30 EDT');
insert into test values(3, '14-09-25 Europe/Bucharest 3:10:30 EEST');

select a, to_timestamp_tz(b, 'YY-MM-DD TZR HH24:MI:SS TZD') from test order by 1; 
drop test;
