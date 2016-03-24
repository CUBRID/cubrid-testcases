--implicit conversion from bit/blob/clob types to TIMESTAMP(L)TZ types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (B'10101010');
insert into tz_test(ts) values (X'aaa');
insert into tz_test(ts) values (bit_to_blob(B'1010'));
insert into tz_test(ts) values (char_to_clob('2000-12-12 13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (select a from bbc_types);
insert into tz_test(ts) values (select b from bbc_types);
insert into tz_test(ts) values (select c from bbc_types);
insert into tz_test(ts) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(tsltz) values (B'10101010');
insert into tz_test(tsltz) values (X'aaa');
insert into tz_test(tsltz) values (bit_to_blob(B'1010'));
insert into tz_test(tsltz) values (char_to_clob('2000-12-12 13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to tsltz types
insert into tz_test(tsltz) values (select a from bbc_types);
insert into tz_test(tsltz) values (select b from bbc_types);
insert into tz_test(tsltz) values (select c from bbc_types);
insert into tz_test(tsltz) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to tstz types
insert into tz_test(tstz) values (B'10101010');
insert into tz_test(tstz) values (X'aaa');
insert into tz_test(tstz) values (bit_to_blob(B'1010'));
insert into tz_test(tstz) values (char_to_clob('2000-12-12 13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to tstz types
insert into tz_test(tstz) values (select a from bbc_types);
insert into tz_test(tstz) values (select b from bbc_types);
insert into tz_test(tstz) values (select c from bbc_types);
insert into tz_test(tstz) values (select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
