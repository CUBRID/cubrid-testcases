--implicit conversion from TIME(L)TZ columns to numeric types, in insert 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
insert into numeric_types(a) values (time'2:00:00');
insert into numeric_types(b) values (time'2:00:00');
insert into numeric_types(c) values (time'2:00:00');
insert into numeric_types(d) values (time'2:00:00');
insert into numeric_types(e) values (time'2:00:00');
insert into numeric_types(f) values (time'2:00:00');
--test: [er] implicit conversion from ts column to numeric types
insert into numeric_types(a) values (select ts from tz_test);
insert into numeric_types(b) values (select ts from tz_test);
insert into numeric_types(c) values (select ts from tz_test);
insert into numeric_types(d) values (select ts from tz_test);
insert into numeric_types(e) values (select ts from tz_test);
insert into numeric_types(f) values (select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to numeric types
insert into numeric_types(a) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into numeric_types(b) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into numeric_types(c) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into numeric_types(d) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into numeric_types(e) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into numeric_types(f) values (datetimeltz'2015-9-17 2:00:00 -5:00');
--test: [er] implicit conversion from tltz column to numeric types
insert into numeric_types(a) values (select tltz from tz_test);
insert into numeric_types(b) values (select tltz from tz_test);
insert into numeric_types(c) values (select tltz from tz_test);
insert into numeric_types(d) values (select tltz from tz_test);
insert into numeric_types(e) values (select tltz from tz_test);
insert into numeric_types(f) values (select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to numeric types
insert into numeric_types(a) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(b) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(d) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(e) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(f) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from ttz column to numeric types
insert into numeric_types(a) values (select ttz from tz_test);
insert into numeric_types(b) values (select ttz from tz_test);
insert into numeric_types(c) values (select ttz from tz_test);
insert into numeric_types(d) values (select ttz from tz_test);
insert into numeric_types(e) values (select ttz from tz_test);
insert into numeric_types(f) values (select ttz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
