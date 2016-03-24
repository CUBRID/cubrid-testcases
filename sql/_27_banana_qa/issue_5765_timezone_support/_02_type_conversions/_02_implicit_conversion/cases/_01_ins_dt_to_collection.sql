--implicit conversion from DATETIME(L)TZ columns to collection types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
insert into collection_types(a) values (datetime'1980-10-01 2:00:00.999');
insert into collection_types(b) values (datetime'1980-10-01 2:00:00.999');
insert into collection_types(c) values (datetime'1980-10-01 2:00:00.999');
--test: [er] implicit conversion from ts column to collection types
insert into collection_types(a) values (select ts from tz_test);
insert into collection_types(b) values (select ts from tz_test);
insert into collection_types(c) values (select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to collection types
insert into collection_types(a) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into collection_types(b) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
insert into collection_types(c) values (datetimeltz'1980-10-01 2:00:00.999 -5:00');
--test: [er] implicit conversion from dtltz column to collection types
insert into collection_types(a) values (select dtltz from tz_test);
insert into collection_types(b) values (select dtltz from tz_test);
insert into collection_types(c) values (select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to collection types
insert into collection_types(a) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into collection_types(b) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into collection_types(c) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
--test: [er] implicit conversion from dttz column to collection types
insert into collection_types(a) values (select dttz from tz_test);
insert into collection_types(b) values (select dttz from tz_test);
insert into collection_types(c) values (select dttz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
