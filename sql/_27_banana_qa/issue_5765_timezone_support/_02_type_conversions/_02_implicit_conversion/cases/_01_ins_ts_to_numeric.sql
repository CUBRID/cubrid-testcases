--implicit conversion from TIMESTAMP(L)TZ columns to numeric types, in insert 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to numeric types
insert into numeric_types(a) values (timestamp'1980-10-01 2:00:00');
insert into numeric_types(b) values (timestamp'1980-10-01 2:00:00');
insert into numeric_types(c) values (timestamp'1980-10-01 2:00:00');
insert into numeric_types(d) values (timestamp'1980-10-01 2:00:00');
insert into numeric_types(e) values (timestamp'1980-10-01 2:00:00');
insert into numeric_types(f) values (timestamp'1980-10-01 2:00:00');
--test: [er] implicit conversion from ts column to numeric types
insert into numeric_types(a) values (select ts from tz_test);
insert into numeric_types(b) values (select ts from tz_test);
insert into numeric_types(c) values (select ts from tz_test);
insert into numeric_types(d) values (select ts from tz_test);
insert into numeric_types(e) values (select ts from tz_test);
insert into numeric_types(f) values (select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to numeric types
insert into numeric_types(a) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into numeric_types(b) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into numeric_types(c) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into numeric_types(d) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into numeric_types(e) values (timestampltz'1980-10-01 2:00:00 -5:00');
insert into numeric_types(f) values (timestampltz'1980-10-01 2:00:00 -5:00');
--test: [er] implicit conversion from tsltz column to numeric types
insert into numeric_types(a) values (select tsltz from tz_test);
insert into numeric_types(b) values (select tsltz from tz_test);
insert into numeric_types(c) values (select tsltz from tz_test);
insert into numeric_types(d) values (select tsltz from tz_test);
insert into numeric_types(e) values (select tsltz from tz_test);
insert into numeric_types(f) values (select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to numeric types
insert into numeric_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(d) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(e) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into numeric_types(f) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from tstz column to numeric types
insert into numeric_types(a) values (select tstz from tz_test);
insert into numeric_types(b) values (select tstz from tz_test);
insert into numeric_types(c) values (select tstz from tz_test);
insert into numeric_types(d) values (select tstz from tz_test);
insert into numeric_types(e) values (select tstz from tz_test);
insert into numeric_types(f) values (select tstz from tz_test);


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
