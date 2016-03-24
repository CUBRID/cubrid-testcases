--implicit conversion from TIMESTAMP(L)TZ columns to collection types, in update


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table collection_types(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);
insert into collection_types values({timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
update collection_types set a=timestamp'1980-10-01 2:00:00';
update collection_types set b=timestamp'1980-10-01 2:00:00';
update collection_types set c=timestamp'1980-10-01 2:00:00';
--test: [er] implicit conversion from ts column to collection types
update collection_types set a=(select ts from tz_test);
update collection_types set b=(select ts from tz_test);
update collection_types set c=(select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to collection types
update collection_types set a=timestampltz'1980-10-01 2:00:00 -5:00';
update collection_types set b=timestampltz'1980-10-01 2:00:00 -5:00';
update collection_types set c=timestampltz'1980-10-01 2:00:00 -5:00';
--test: [er] implicit conversion from tsltz column to collection types
update collection_types set a=(select tsltz from tz_test);
update collection_types set b=(select tsltz from tz_test);
update collection_types set c=(select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to collection types
update collection_types set a=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update collection_types set b=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update collection_types set c=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from tstz column to collection types
update collection_types set a=(select tstz from tz_test);
update collection_types set b=(select tstz from tz_test);
update collection_types set c=(select tstz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
