--implicit conversion from collection types to TIMESTAMP(L)TZ types, in insert 


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamptz'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table collection_types(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);
insert into collection_types values({timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'}, {timestampltz'2000-01-01 12:13:14 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from collection types to ts types
insert into tz_test(ts) values ({timestamptz'2000-01-01 12:13:14'});
insert into tz_test(ts) values ({timestamptz'2000-01-01 12:13:14 +4:00'});
insert into tz_test(ts) values ({timestamptz'2000-01-01 12:13:14 America/New_York'});
--test: [er] implicit conversion from collection types to ts types
insert into tz_test(ts) values (select a from collection_types);
insert into tz_test(ts) values (select b from collection_types);
insert into tz_test(ts) values (select c from collection_types);

--test: [er] implicit conversion from collection types to ts types
insert into tz_test(tsltz) values ({timestamptz'2000-01-01 12:13:14'});
insert into tz_test(tsltz) values ({timestamptz'2000-01-01 12:13:14 +4:00'});
insert into tz_test(tsltz) values ({timestamptz'2000-01-01 12:13:14 America/New_York'});
--test: [er] implicit conversion from collection types to tsltz types
insert into tz_test(tsltz) values (select a from collection_types);
insert into tz_test(tsltz) values (select b from collection_types);
insert into tz_test(tsltz) values (select c from collection_types);

--test: [er] implicit conversion from collection types to tstz types
insert into tz_test(tstz) values ({timestamptz'2000-01-01 12:13:14'});
insert into tz_test(tstz) values ({timestamptz'2000-01-01 12:13:14 +4:00'});
insert into tz_test(tstz) values ({timestamptz'2000-01-01 12:13:14 America/New_York'});
--test: [er] implicit conversion from collection types to tstz types
insert into tz_test(tstz) values (select a from collection_types);
insert into tz_test(tstz) values (select b from collection_types);
insert into tz_test(tstz) values (select c from collection_types);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
