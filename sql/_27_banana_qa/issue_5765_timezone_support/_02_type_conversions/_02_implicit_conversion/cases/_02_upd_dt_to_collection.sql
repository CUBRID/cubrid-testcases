--implicit conversion from DATETIME(L)TZ columns to collection types, in update


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);
insert into collection_types values({datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
update collection_types set a=datetime'1980-10-01 2:00:00.999';
update collection_types set b=datetime'1980-10-01 2:00:00.999';
update collection_types set c=datetime'1980-10-01 2:00:00.999';
--test: [er] implicit conversion from ts column to collection types
update collection_types set a=(select ts from tz_test);
update collection_types set b=(select ts from tz_test);
update collection_types set c=(select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to collection types
update collection_types set a=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update collection_types set b=datetimeltz'1980-10-01 2:00:00.999 -5:00';
update collection_types set c=datetimeltz'1980-10-01 2:00:00.999 -5:00';
--test: [er] implicit conversion from dtltz column to collection types
update collection_types set a=(select dtltz from tz_test);
update collection_types set b=(select dtltz from tz_test);
update collection_types set c=(select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to collection types
update collection_types set a=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update collection_types set b=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update collection_types set c=datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
--test: [er] implicit conversion from dttz column to collection types
update collection_types set a=(select dttz from tz_test);
update collection_types set b=(select dttz from tz_test);
update collection_types set c=(select dttz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
