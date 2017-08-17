--implicit conversion from character string types to DATETIME(L)TZ types, in insert 


autocommit off;
drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment(1,1), ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';

create table character_types(id int auto_increment, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('08:00:00.999 PM 12/01/2020', '12:00:01.999 PM 01/02/2019 +08:00', '08:00:00.999 PM 12/01/2020 +09:00', '08:00:00.999 PM 12/01/2020 Asia/Tokyo'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', 3, 1);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', 2, 3);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from character string constant values to ts types
insert into tz_test(ts, dtltz, dttz) values ('1985-10-01 2:00:00.999', '1985-10-01 2:00:00.999', '1985-10-01 2:00:00.999');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01 2:00:00.999 +14:00', '1980-10-01 2:00:00.999 +14:00', '1980-10-01 2:00:00.999 +14:00');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01 2:00:00.999 Indian/Antananarivo', '1980-10-01 2:00:00.999 Indian/Antananarivo', '1980-10-01 2:00:00.999 Indian/Antananarivo');
select * from tz_test order by id;
rollback;
insert into tz_test(ts, dtltz, dttz) values ('1985-10-01 2:00:00.999', '1985-10-01 2:00:00.999', '1985-10-01 2:00:00.999');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01 2:00:00.999 +14:00', '1980-10-01 2:00:00.999 +14:00', '1980-10-01 2:00:00.999 +14:00');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01 2:00:00.999 Indian/Antananarivo', '1980-10-01 2:00:00.999 Indian/Antananarivo', '1980-10-01 2:00:00.999 Indian/Antananarivo');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01', '1980-10-01', '1980-10-01');
insert into tz_test(ts, dtltz, dttz) values ('1980-10-01 Asia/Shanghai', '1980-10-01 Asia/Shanghai', '1980-10-01 Asia/Shanghai');
select * from tz_test order by id;
rollback;
insert into tz_test(ts, dtltz, dttz) values ('86400', '86400', '86400');
select * from tz_test order by id;
rollback;

--test: [er] invalid value
insert into tz_test(ts) values('a');
insert into tz_test(dtltz) values('bb');
insert into tz_test(dttz) values('ccc');
insert into tz_test(ts) select d from character_types; 
insert into tz_test(dtltz) select d from character_types; 
insert into tz_test(dttz) select d from character_types; 

--test: implicit conversion from character string types to ts types
insert into tz_test(ts, dtltz, dttz) select a, a, a from character_types;
insert into tz_test(ts, dtltz, dttz) select a, a, a from character_types where id > 1;
insert into tz_test(ts, dtltz, dttz) select b, b, b from character_types;
insert into tz_test(ts, dtltz, dttz) select b, b, b from character_types where id > 1;
insert into tz_test(ts, dtltz, dttz) select c, c, c from character_types;
insert into tz_test(ts, dtltz, dttz) select c, c, c from character_types where id > 1;
insert into tz_test(ts, dtltz, dttz) select e, e, e from character_types;
insert into tz_test(ts, dtltz, dttz) select e, e, e from character_types where id > 1;
select * from tz_test order by id;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
