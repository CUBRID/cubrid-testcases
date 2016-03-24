--implicit conversion from character string types to TIME(L)TZ types, in insert 


autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';

create table character_types(id int auto_increment, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM', '12:00:01 PM +08:00', '08:00:00 PM +09:00', '08:00:00 PM Asia/Tokyo'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('20:00:00', '20:00:00', '20:00:00', 3, 1);
insert into character_types(a, b, c, d, e) values('20:00:00 +9:00', '20:00:00 +9:00', '20:00:00 +9:00', 2, 3);
insert into character_types(a, b, c, d, e) values('20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', 1, 4);
commit;

set timezone '+9:00';
--test: implicit conversion from character string constant values to ts types
insert into tz_test(ts, tltz, ttz) values ('2:00:00', '2:00:00', '2:00:00');
insert into tz_test(ts, tltz, ttz) values ('2:00:00', '2:00:00 +14:00', '2:00:00 +14:00');
insert into tz_test(ts, tltz, ttz) values ('2:00:00', '2:00:00 Indian/Antananarivo', '2:00:00 Indian/Antananarivo');
select * from tz_test order by id;
rollback;
insert into tz_test(ts, tltz, ttz) values ('2:00:00.789', '2:00:00.789', '2:00:00.789');
insert into tz_test(ts, tltz, ttz) values ('2:00:00.789', '2:00:00.789 +14:00', '2:00:00.789 +14:00');
insert into tz_test(ts, tltz, ttz) values ('2:00:00.789', '2:00:00.789 Indian/Antananarivo', '2:00:00.789 Indian/Antananarivo');
insert into tz_test(ts, tltz, ttz) values ('1980-10-01', '1980-10-01', '1980-10-01');
insert into tz_test(ts, tltz, ttz) values ('Asia/Shanghai', 'Asia/Shanghai', 'Asia/Shanghai');
select * from tz_test order by id;
rollback;
insert into tz_test(ts, tltz, ttz) values ('86400', '86400', '86400');
select * from tz_test order by id;
rollback;

--test: [er] invalid value
insert into tz_test(ts) values('a');
insert into tz_test(tltz) values('bb');
insert into tz_test(ttz) values('ccc');
insert into tz_test(ts) select d from character_types; 
insert into tz_test(tltz) select d from character_types; 
insert into tz_test(ttz) select d from character_types; 

--test: implicit conversion from character string types to ts types
insert into tz_test(ts, tltz, ttz) select a, a, a from character_types;
insert into tz_test(ts, tltz, ttz) select a, a, a from character_types where id > 1;
insert into tz_test(ts, tltz, ttz) select b, b, b from character_types;
insert into tz_test(ts, tltz, ttz) select b, b, b from character_types where id > 1;
insert into tz_test(ts, tltz, ttz) select c, c, c from character_types;
insert into tz_test(ts, tltz, ttz) select c, c, c from character_types where id > 1;
insert into tz_test(ts, tltz, ttz) select e, e, e from character_types;
insert into tz_test(ts, tltz, ttz) select e, e, e from character_types where id > 1;
select * from tz_test order by id;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
