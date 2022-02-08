--test logical operators with DATETIME(L)TZ columns as operands


--test: test with constant values
select (1<>0 AND datetimeltz'2001-04-05 12:45:09.999 +10:00'<>0);
select (datetimetz'2001-04-05 12:45:09.999 +10:00'<>0 OR true);
select (10<>0 XOR datetimeltz'2001-04-05 12:45:09.999 America/Montreal'<>0);
select (NOT datetimetz'2001-04-05 12:45:09.999 America/Montreal'<>0);
select (! datetimetz'2001-04-05 12:45:09.999 America/Montreal'<>0);

--test: test with ts columns
drop table if exists tz_test;
create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -1:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

select (ts<>0 && 1<>0) from tz_test order by 1;
select (true OR ts<>0) from tz_test order by 1;
select (0<>0 XOR ts<>0) from tz_test order by 1;
select (NOT ts<>0) from tz_test order by 1;

select (false && dtltz<>0) from tz_test order by 1;
select (0<>0 OR dtltz<>0) from tz_test order by 1;
select (dtltz<>0 XOR ts<>0) from tz_test order by 1;
select (NOT dtltz<>0) from tz_test order by 1;
select (! dtltz<>0) from tz_test order by 1;

select (dttz<>0 && dtltz<>0) from tz_test order by 1;
select (dttz<>0 OR 0<>0) from tz_test order by 1;
select (dttz || dttz) from tz_test order by 1;
set system parameters 'pipes_as_concat=no';
select (dttz<>0 || dttz<>0) from tz_test order by 1;
set system parameters 'pipes_as_concat=yes';
select (dttz<>0 XOR 1<>0) from tz_test order by 1;
select (NOT dttz<>0) from tz_test order by 1;
select (! dttz<>0) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
