--implicit conversion from DATETIME(L)TZ columns to numeric types, in insert 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
insert into numeric_types(a) values (datetime'1980-10-01 2:00:00.999');
insert into numeric_types(b) values (datetime'1980-10-01 2:00:00.999');
insert into numeric_types(c) values (datetime'1980-10-01 2:00:00.999');
insert into numeric_types(d) values (datetime'1980-10-01 2:00:00.999');
insert into numeric_types(e) values (datetime'1980-10-01 2:00:00.999');
insert into numeric_types(f) values (datetime'1980-10-01 2:00:00.999');
--test: [er] implicit conversion from ts column to numeric types
insert into numeric_types(a) values (select ts from tz_test);
insert into numeric_types(b) values (select ts from tz_test);
insert into numeric_types(c) values (select ts from tz_test);
insert into numeric_types(d) values (select ts from tz_test);
insert into numeric_types(e) values (select ts from tz_test);
insert into numeric_types(f) values (select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to numeric types
insert into numeric_types(a) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into numeric_types(b) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into numeric_types(c) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into numeric_types(d) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into numeric_types(e) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into numeric_types(f) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
--test: [er] implicit conversion from dtltz column to numeric types
insert into numeric_types(a) values (select dtltz from tz_test);
insert into numeric_types(b) values (select dtltz from tz_test);
insert into numeric_types(c) values (select dtltz from tz_test);
insert into numeric_types(d) values (select dtltz from tz_test);
insert into numeric_types(e) values (select dtltz from tz_test);
insert into numeric_types(f) values (select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to numeric types
insert into numeric_types(a) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into numeric_types(b) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into numeric_types(c) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into numeric_types(d) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into numeric_types(e) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into numeric_types(f) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
--test: [er] implicit conversion from dttz column to numeric types
insert into numeric_types(a) values (select dttz from tz_test);
insert into numeric_types(b) values (select dttz from tz_test);
insert into numeric_types(c) values (select dttz from tz_test);
insert into numeric_types(d) values (select dttz from tz_test);
insert into numeric_types(e) values (select dttz from tz_test);
insert into numeric_types(f) values (select dttz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
