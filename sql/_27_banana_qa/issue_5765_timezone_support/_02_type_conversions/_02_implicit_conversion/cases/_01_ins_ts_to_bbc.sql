--implicit conversion from TIMESTAMP(L)TZ columns to bit/blob/clob types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
insert into bbc_types(a) values (timestamptz'1980-10-01 2:00:00');
insert into bbc_types(b) values (timestamptz'1980-10-01 2:00:00');
insert into bbc_types(c) values (timestamptz'1980-10-01 2:00:00');
insert into bbc_types(d) values (timestamptz'1980-10-01 2:00:00');
--test: [er] implicit conversion from ts column to bit/blob/clob types
insert into bbc_types(a) values (select ts from tz_test);
insert into bbc_types(b) values (select ts from tz_test);
insert into bbc_types(c) values (select ts from tz_test);
insert into bbc_types(d) values (select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to bit/blob/clob types
insert into bbc_types(a) values (timestamptz'1980-10-01 2:00:00 -5:00');
insert into bbc_types(b) values (timestamptz'1980-10-01 2:00:00 -5:00');
insert into bbc_types(c) values (timestamptz'1980-10-01 2:00:00 -5:00');
insert into bbc_types(d) values (timestamptz'1980-10-01 2:00:00 -5:00');
--test: [er] implicit conversion from tsltz column to bit/blob/clob types
insert into bbc_types(a) values (select tsltz from tz_test);
insert into bbc_types(b) values (select tsltz from tz_test);
insert into bbc_types(c) values (select tsltz from tz_test);
insert into bbc_types(d) values (select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to bit/blob/clob types
insert into bbc_types(a) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(b) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(c) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(d) values (timestamptz'1980-10-01 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from tstz column to bit/blob/clob types
insert into bbc_types(a) values (select tstz from tz_test);
insert into bbc_types(b) values (select tstz from tz_test);
insert into bbc_types(c) values (select tstz from tz_test);
insert into bbc_types(d) values (select tstz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
