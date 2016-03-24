--implicit conversion from TIMESTAMP(L)TZ columns to collection types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table collection_types(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
insert into collection_types(a) values (timestamp'1980-10-01 2:00:00');
insert into collection_types(b) values (timestamp'1980-10-01 2:00:00');
insert into collection_types(c) values (timestamp'1980-10-01 2:00:00');
--test: [er] implicit conversion from ts column to collection types
insert into collection_types(a) values (select ts from tz_test);
insert into collection_types(b) values (select ts from tz_test);
insert into collection_types(c) values (select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to collection types
insert into collection_types(a) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into collection_types(b) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into collection_types(c) values (timestampltz'1980-10-01 2:00:00 -5:00');
--test: [er] implicit conversion from tsltz column to collection types
insert into collection_types(a) values (select tsltz from tz_test);
insert into collection_types(b) values (select tsltz from tz_test);
insert into collection_types(c) values (select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to collection types
insert into collection_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into collection_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into collection_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from tstz column to collection types
insert into collection_types(a) values (select tstz from tz_test);
insert into collection_types(b) values (select tstz from tz_test);
insert into collection_types(c) values (select tstz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
