--test logical operators with DATETIME(L)TZ columns as operands


--test: test with constant values
select (1 AND datetimeltz'2001-04-05 12:45:09.999 +10:00');
select (datetimetz'2001-04-05 12:45:09.999 +10:00' OR true);
select (10 XOR datetimeltz'2001-04-05 12:45:09.999 America/Montreal');
select (NOT datetimetz'2001-04-05 12:45:09.999 America/Montreal');
select (! datetimetz'2001-04-05 12:45:09.999 America/Montreal');

--test: test with ts columns
drop table if exists tz_test;
create table tz_test(a int, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'UTC';
insert into tz_test values(1, datetimeltz'2019-01-02 12:00:01.999', datetimeltz'2019-01-02 12:00:01.999', datetimetz'2019-01-02 12:00:01.999');
insert into tz_test values(2, datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimeltz'2019-01-02 12:00:01.999 -10:00', datetimetz'2019-01-02 12:00:01.999 -1:00');
insert into tz_test values(3, datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimeltz'2019-01-02 12:00:01.999 +8:00', datetimetz'2019-01-02 12:00:01.999 +8:00');
insert into tz_test values(4, datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimeltz'2019-01-02 12:00:01.999 Asia/Tokyo', datetimetz'2019-01-02 12:00:01.999 Asia/Tokyo');

select (ts && 1) from tz_test order by 1;
select (true OR ts) from tz_test order by 1;
select (0 XOR ts) from tz_test order by 1;
select (NOT ts) from tz_test order by 1;

select (false && dtltz) from tz_test order by 1;
select (0 OR dtltz) from tz_test order by 1;
select (dtltz XOR ts) from tz_test order by 1;
select (NOT dtltz) from tz_test order by 1;
select (! dtltz) from tz_test order by 1;

select (dttz && dtltz) from tz_test order by 1;
select (dttz OR 0) from tz_test order by 1;
select (dttz || dttz) from tz_test order by 1;
set system parameters 'pipes_as_concat=no';
select (dttz || dttz) from tz_test order by 1;
set system parameters 'pipes_as_concat=yes';
select (dttz XOR 1) from tz_test order by 1;
select (NOT dttz) from tz_test order by 1;
select (! dttz) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
