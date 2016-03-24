--implicit conversion from character string types to DATETIME(L)TZ types, in update

autocommit off;

drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'2020-12-1 20:00:00.999', datetimeltz'2020-12-1 20:00:00.999', datetimetz'2020-12-1 20:00:00.999 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('08:00:00.999 PM 12/01/2020', '12:00:01.999 PM 01/02/2019 +08:00', '08:00:00.999 PM 12/01/2020 +09:00', '08:00:00.999 PM 12/01/2020 Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', 3, 1);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', 2, 3);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from character string constant values to ts types
update tz_test set ts='1985-10-01 2:00:00.999', dtltz='1985-10-01 2:00:00.999', dttz='1985-10-01 2:00:00.999';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.999 +14:00', dtltz='1980-10-01 2:00:00.999 +14:00', dttz='1980-10-01 2:00:00.999 +14:00';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.999 Indian/Antananarivo', dtltz='1980-10-01 2:00:00.999 Indian/Antananarivo', dttz='1980-10-01 2:00:00.999 Indian/Antananarivo';
-- 3:00
select * from tz_test order by id;
rollback;

update tz_test set ts='1985-10-01 2:00:00.999.789', dtltz='1985-10-01 2:00:00.999.789', dttz='1985-10-01 2:00:00.999.789';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.999.789 +14:00', dtltz='1980-10-01 2:00:00.999.789 +14:00', dttz='1980-10-01 2:00:00.999.789 +14:00';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.999.789 Indian/Antananarivo', dtltz='1980-10-01 2:00:00.999.789 Indian/Antananarivo', dttz='1980-10-01 2:00:00.999.789 Indian/Antananarivo';
select * from tz_test order by id;
rollback;
update tz_test set ts='1980-10-01', dtltz='1980-10-01', dttz='1980-10-01';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 Asia/Shanghai', dtltz='1980-10-01 Asia/Shanghai', dttz='1980-10-01 Asia/Shanghai';
select * from tz_test order by id;
update tz_test set ts='86400', dtltz='86400', dttz='86400';
select * from tz_test order by id;
rollback;

--test: [er] invalid value
update tz_test set ts='a';
update tz_test set dtltz='bb';
update tz_test set dttz='ccc';
update tz_test set ts=(select d from character_types limit 1); 
update tz_test set dtltz=(select d from character_types limit 1); 
update tz_test set dttz=(select d from character_types limit 1); 

--test: implicit conversion from character string types to ts types
update tz_test set ts=(select a from character_types where id=1), dtltz=(select a from character_types where id=1), dttz=(select a from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select b from character_types where id=1), dtltz=(select b from character_types where id=1), dttz=(select b from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select c from character_types where id=1), dtltz=(select c from character_types where id=1), dttz=(select c from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select e from character_types where id=1), dtltz=(select e from character_types where id=1), dttz=(select e from character_types where id=1);
select * from tz_test order by id;
rollback;

update tz_test set ts=(select a from character_types where id=2), dtltz=(select a from character_types where id=2), dttz=(select a from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=2), dtltz=(select b from character_types where id=2), dttz=(select b from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=2), dtltz=(select c from character_types where id=2), dttz=(select c from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=2), dtltz=(select e from character_types where id=2), dttz=(select e from character_types where id=2);
select * from tz_test order by id; 
rollback;

update tz_test set ts=(select a from character_types where id=3), dtltz=(select a from character_types where id=3), dttz=(select a from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=3), dtltz=(select b from character_types where id=3), dttz=(select b from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=3), dtltz=(select c from character_types where id=3), dttz=(select c from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=3), dtltz=(select e from character_types where id=3), dttz=(select e from character_types where id=3);
select * from tz_test order by id; 
rollback;

update tz_test set ts=(select a from character_types where id=4), dtltz=(select a from character_types where id=4), dttz=(select a from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=4), dtltz=(select b from character_types where id=4), dttz=(select b from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=4), dtltz=(select c from character_types where id=4), dttz=(select c from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=4), dtltz=(select e from character_types where id=4), dttz=(select e from character_types where id=4);
select * from tz_test order by id; 
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
