--implicit conversion from TIME(L)TZ columns to numeric types, in update 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
update numeric_types set a=time'2:00:00';
update numeric_types set b=time'2:00:00';
update numeric_types set c=time'2:00:00';
update numeric_types set d=time'2:00:00';
update numeric_types set e=time'2:00:00';
update numeric_types set f=time'2:00:00';
--test: [er] implicit conversion from ts column to numeric types
update numeric_types set a=(select ts from tz_test);
update numeric_types set b=(select ts from tz_test);
update numeric_types set c=(select ts from tz_test);
update numeric_types set d=(select ts from tz_test);
update numeric_types set e=(select ts from tz_test);
update numeric_types set f=(select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to numeric types
update numeric_types set a=datetimeltz'2015-9-17 2:00:00 -5:00';
update numeric_types set b=datetimeltz'2015-9-17 2:00:00 -5:00';
update numeric_types set c=datetimeltz'2015-9-17 2:00:00 -5:00';
update numeric_types set d=datetimeltz'2015-9-17 2:00:00 -5:00';
update numeric_types set e=datetimeltz'2015-9-17 2:00:00 -5:00';
update numeric_types set f=datetimeltz'2015-9-17 2:00:00 -5:00';
--test: [er] implicit conversion from tltz column to numeric types
update numeric_types set a=(select tltz from tz_test);
update numeric_types set b=(select tltz from tz_test);
update numeric_types set c=(select tltz from tz_test);
update numeric_types set d=(select tltz from tz_test);
update numeric_types set e=(select tltz from tz_test);
update numeric_types set f=(select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to numeric types
update numeric_types set a=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update numeric_types set b=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update numeric_types set c=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update numeric_types set d=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update numeric_types set e=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update numeric_types set f=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from ttz column to numeric types
update numeric_types set a=(select ttz from tz_test);
update numeric_types set b=(select ttz from tz_test);
update numeric_types set c=(select ttz from tz_test);
update numeric_types set d=(select ttz from tz_test);
update numeric_types set e=(select ttz from tz_test);
update numeric_types set f=(select ttz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
