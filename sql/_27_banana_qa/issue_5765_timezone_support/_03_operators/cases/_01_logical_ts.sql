--test logical operators with TIMESTAMP(L)TZ columns as operands


--test: test with constant values
select (1 AND timestampltz'2001-04-05 12:45:09 +10:00');
select (timestamptz'2001-04-05 12:45:09 +10:00' OR true);
select (10 XOR timestampltz'2001-04-05 12:45:09 America/Montreal');
select (NOT timestamptz'2001-04-05 12:45:09 America/Montreal');
select (! timestamptz'2001-04-05 12:45:09 America/Montreal');

--test: test with ts columns
drop table if exists tz_test;
create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -1:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

select (ts && 1) from tz_test order by 1;
select (true OR ts) from tz_test order by 1;
select (0 XOR ts) from tz_test order by 1;
select (NOT ts) from tz_test order by 1;

select (false && tsltz) from tz_test order by 1;
select (0 OR tsltz) from tz_test order by 1;
select (tsltz XOR ts) from tz_test order by 1;
select (NOT tsltz) from tz_test order by 1;
select (! tsltz) from tz_test order by 1;

select (tstz && tsltz) from tz_test order by 1;
select (tstz OR 0) from tz_test order by 1;
select (tstz || tstz) from tz_test order by 1;
set system parameters 'pipes_as_concat=no';
select (tstz || tstz) from tz_test order by 1;
set system parameters 'pipes_as_concat=yes';
select (tstz XOR 1) from tz_test order by 1;
select (NOT tstz) from tz_test order by 1;
select (! tstz) from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
