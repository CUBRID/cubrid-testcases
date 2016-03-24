--implicit conversion from TIMESTAMP(L)TZ columns to numeric types, in update 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
update numeric_types set a=timestamp'1980-10-01 2:00:00';
update numeric_types set b=timestamp'1980-10-01 2:00:00';
update numeric_types set c=timestamp'1980-10-01 2:00:00';
update numeric_types set d=timestamp'1980-10-01 2:00:00';
update numeric_types set e=timestamp'1980-10-01 2:00:00';
update numeric_types set f=timestamp'1980-10-01 2:00:00';
--test: [er] implicit conversion from ts column to numeric types
update numeric_types set a=(select ts from tz_test);
update numeric_types set b=(select ts from tz_test);
update numeric_types set c=(select ts from tz_test);
update numeric_types set d=(select ts from tz_test);
update numeric_types set e=(select ts from tz_test);
update numeric_types set f=(select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to numeric types
update numeric_types set a=timestampltz'1980-10-01 2:00:00 -5:00';
update numeric_types set b=timestampltz'1980-10-01 2:00:00 -5:00';
update numeric_types set c=timestampltz'1980-10-01 2:00:00 -5:00';
update numeric_types set d=timestampltz'1980-10-01 2:00:00 -5:00';
update numeric_types set e=timestampltz'1980-10-01 2:00:00 -5:00';
update numeric_types set f=timestampltz'1980-10-01 2:00:00 -5:00';
--test: [er] implicit conversion from tsltz column to numeric types
update numeric_types set a=(select tsltz from tz_test);
update numeric_types set b=(select tsltz from tz_test);
update numeric_types set c=(select tsltz from tz_test);
update numeric_types set d=(select tsltz from tz_test);
update numeric_types set e=(select tsltz from tz_test);
update numeric_types set f=(select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to numeric types
update numeric_types set a=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update numeric_types set b=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update numeric_types set c=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update numeric_types set d=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update numeric_types set e=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
update numeric_types set f=timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from tstz column to numeric types
update numeric_types set a=(select tstz from tz_test);
update numeric_types set b=(select tstz from tz_test);
update numeric_types set c=(select tstz from tz_test);
update numeric_types set d=(select tstz from tz_test);
update numeric_types set e=(select tstz from tz_test);
update numeric_types set f=(select tstz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
