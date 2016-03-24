--implicit conversion from DATETIME(L)TZ columns to numeric types, in update 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
update numeric_types set a=datetime'1980-10-01 2:00:00.999';
update numeric_types set b=datetime'1980-10-01 2:00:00.999';
update numeric_types set c=datetime'1980-10-01 2:00:00.999';
update numeric_types set d=datetime'1980-10-01 2:00:00.999';
update numeric_types set e=datetime'1980-10-01 2:00:00.999';
update numeric_types set f=datetime'1980-10-01 2:00:00.999';
--test: [er] implicit conversion from ts column to numeric types
update numeric_types set a=(select ts from tz_test);
update numeric_types set b=(select ts from tz_test);
update numeric_types set c=(select ts from tz_test);
update numeric_types set d=(select ts from tz_test);
update numeric_types set e=(select ts from tz_test);
update numeric_types set f=(select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to numeric types
update numeric_types set a=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update numeric_types set b=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update numeric_types set c=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update numeric_types set d=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update numeric_types set e=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update numeric_types set f=datetimeltz'1980-10-01 2:00:00.999 -5:00';
--test: [er] implicit conversion from dtltz column to numeric types
update numeric_types set a=(select dtltz from tz_test);
update numeric_types set b=(select dtltz from tz_test);
update numeric_types set c=(select dtltz from tz_test);
update numeric_types set d=(select dtltz from tz_test);
update numeric_types set e=(select dtltz from tz_test);
update numeric_types set f=(select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to numeric types
update numeric_types set a=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update numeric_types set b=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update numeric_types set c=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update numeric_types set d=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update numeric_types set e=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update numeric_types set f=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
--test: [er] implicit conversion from dttz column to numeric types
update numeric_types set a=(select dttz from tz_test);
update numeric_types set b=(select dttz from tz_test);
update numeric_types set c=(select dttz from tz_test);
update numeric_types set d=(select dttz from tz_test);
update numeric_types set e=(select dttz from tz_test);
update numeric_types set f=(select dttz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
