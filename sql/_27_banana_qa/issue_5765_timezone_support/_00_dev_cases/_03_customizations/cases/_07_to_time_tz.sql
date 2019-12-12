select to_time_tz('23:59:59');
--BUG: CUBRIDSUS-17316, resolved
select to_time_tz('13:10:30 Africa/Banjul GMT', 'HH24:MI:SS TZR TZD');
select to_time_tz('10:10:10 Africa/Banjul GMT', 'HH24:MI:SS TZR TZD');
select to_time_tz('8:9:10 Asia/Shanghai CST +13', 'HH24:MI:SS TZR TZD TZH');
select to_time_tz('8:9:10 +13', 'HH24:MI:SS TZH');
select to_time_tz('8:9:10 -11', 'HH24:MI:SS TZH');
select to_time_tz('10:10:10 +13', 'HH24:MI:SS TZM');
select to_time_tz('10:10:10 -11', 'HH24:MI:SS TZM');
select to_time_tz('10:10:10 23', 'HH24:MI:SS TZM');
select to_time_tz('10:10:10 0 23', 'HH24:MI:SS TZH TZM');
select to_time_tz('Asia/Shanghai 8:9:10 CST', 'TZR HH24:MI:SS TZD');
select to_time_tz('CST 8:9:10 Asia/Shanghai', 'TZD HH24:MI:SS TZR');
select to_time_tz('Asia/Shanghai CDT 8:9:10', 'TZR TZD HH24:MI:SS');
select to_time_tz('CST 8:9:10', 'TZD HH24:MI:SS');
select to_time_tz('GMT,  GMT Asia/Shanghai Africa/Banjul 8:9:10', 'TZD,  TZD TZR TZR HH24:MI:SS');
select to_time_tz('-22 8:9:10', 'TZH HH24:MI:SS');
select to_time_tz('12 8:9:10', 'TZM HH24:MI:SS');
select to_time_tz('-12 25 8:9:10', 'TZH TZM HH24:MI:SS');
select to_time_tz('-12 25,+ 25  8:9:10', 'TZH TZM,TZH HH24:MI:SS');

drop table if exists test;
create table test (a int , b string);
insert into test values(1, '13:10:30 Asia/Tbilisi GET');
insert into test values(2, '10:10:10 Asia/Oral ORAT');
insert into test values(3, '11:12:24 Indian/Maldives MVT');

select a, to_time_tz(b, 'HH24:MI:SS TZR TZD') from test; 
drop test;
