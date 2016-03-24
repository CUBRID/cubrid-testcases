--implicit conversion from bit/blob/clob types to DATETIME(L)TZ types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56.999 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (B'10101010');
insert into tz_test(ts) values (X'aaa');
insert into tz_test(ts) values (bit_to_blob(B'1010'));
insert into tz_test(ts) values (char_to_clob('2000-12-12 13:13:13.999'));
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (select a from bbc_types);
insert into tz_test(ts) values (select b from bbc_types);
insert into tz_test(ts) values (select c from bbc_types);
insert into tz_test(ts) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(dtltz) values (B'10101010');
insert into tz_test(dtltz) values (X'aaa');
insert into tz_test(dtltz) values (bit_to_blob(B'1010'));
insert into tz_test(dtltz) values (char_to_clob('2000-12-12 13:13:13.999'));
--test: [er] implicit conversion from bit/blob/clob types to dtltz types
insert into tz_test(dtltz) values (select a from bbc_types);
insert into tz_test(dtltz) values (select b from bbc_types);
insert into tz_test(dtltz) values (select c from bbc_types);
insert into tz_test(dtltz) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to dttz types
insert into tz_test(dttz) values (B'10101010');
insert into tz_test(dttz) values (X'aaa');
insert into tz_test(dttz) values (bit_to_blob(B'1010'));
insert into tz_test(dttz) values (char_to_clob('2000-12-12 13:13:13.999'));
--test: [er] implicit conversion from bit/blob/clob types to dttz types
insert into tz_test(dttz) values (select a from bbc_types);
insert into tz_test(dttz) values (select b from bbc_types);
insert into tz_test(dttz) values (select c from bbc_types);
insert into tz_test(dttz) values (select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
