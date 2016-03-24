--implicit conversion from collection types to TIMESTAMP(L)TZ types, in insert 


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values(timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table collection_types(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);
insert into collection_types values({timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts={timestamptz'2000-01-01 12:13:14'};
update tz_test set ts={timestamptz'2000-01-01 12:13:14 +4:00'};
update tz_test set ts={timestamptz'2000-01-01 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts=(select a from collection_types);
update tz_test set ts=(select b from collection_types);
update tz_test set ts=(select c from collection_types);

--test: [er] implicit conversion from collection types to ts types
update tz_test set tsltz={timestamptz'2000-01-01 12:13:14'};
update tz_test set tsltz={timestamptz'2000-01-01 12:13:14 +4:00'};
update tz_test set tsltz={timestamptz'2000-01-01 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to tsltz types
update tz_test set tsltz=(select a from collection_types);
update tz_test set tsltz=(select b from collection_types);
update tz_test set tsltz=(select c from collection_types);

--test: [er] implicit conversion from collection types to tstz types
update tz_test set tstz={timestamptz'2000-01-01 12:13:14'};
update tz_test set tstz={timestamptz'2000-01-01 12:13:14 +4:00'};
pdate tz_test set tstz={timestamptz'2000-01-01 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to tstz types
update tz_test set tstz=(select a from collection_types);
update tz_test set tstz=(select b from collection_types);
update tz_test set tstz=(select c from collection_types);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
