--implicit conversion from bit/blob/clob types to TIME(L)TZ types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (B'10101010');
insert into tz_test(ts) values (X'aaa');
insert into tz_test(ts) values (bit_to_blob(B'1010'));
insert into tz_test(ts) values (char_to_clob('13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(ts) values (select a from bbc_types);
insert into tz_test(ts) values (select b from bbc_types);
insert into tz_test(ts) values (select c from bbc_types);
insert into tz_test(ts) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to ts types
insert into tz_test(tltz) values (B'10101010');
insert into tz_test(tltz) values (X'aaa');
insert into tz_test(tltz) values (bit_to_blob(B'1010'));
insert into tz_test(tltz) values (char_to_clob('13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to tltz types
insert into tz_test(tltz) values (select a from bbc_types);
insert into tz_test(tltz) values (select b from bbc_types);
insert into tz_test(tltz) values (select c from bbc_types);
insert into tz_test(tltz) values (select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to ttz types
insert into tz_test(ttz) values (B'10101010');
insert into tz_test(ttz) values (X'aaa');
insert into tz_test(ttz) values (bit_to_blob(B'1010'));
insert into tz_test(ttz) values (char_to_clob('13:13:13'));
--test: [er] implicit conversion from bit/blob/clob types to ttz types
insert into tz_test(ttz) values (select a from bbc_types);
insert into tz_test(ttz) values (select b from bbc_types);
insert into tz_test(ttz) values (select c from bbc_types);
insert into tz_test(ttz) values (select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
