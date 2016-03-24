--implicit conversion from character string types to TIMESTAMP(L)TZ types, in update

autocommit off;

drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'2020-12-1 20:00:00', timestampltz'2020-12-1 20:00:00', timestamptz'2020-12-1 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM 12/01/2020', '12:00:01 PM 01/02/2019 +08:00', '08:00:00 PM 12/01/2020 +09:00', '08:00:00 PM 12/01/2020 Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00', '2020-12-1 20:00:00', '2020-12-1 20:00:00', 3, 1);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', 2, 3);
insert into character_types(a, b, c, d, e) values('2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', 1, 4);
commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from character string constant values to ts types
update tz_test set ts='1985-10-01 2:00:00', tsltz='1985-10-01 2:00:00', tstz='1985-10-01 2:00:00';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00 +14:00', tsltz='1980-10-01 2:00:00 +14:00', tstz='1980-10-01 2:00:00 +14:00';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00 Indian/Antananarivo', tsltz='1980-10-01 2:00:00 Indian/Antananarivo', tstz='1980-10-01 2:00:00 Indian/Antananarivo';
-- 3:00
select * from tz_test order by id;
rollback;

--BUG: CUBRIDSUS-15166, resolved
update tz_test set ts='1985-10-01 2:00:00.789', tsltz='1985-10-01 2:00:00.789', tstz='1985-10-01 2:00:00.789';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.789 +14:00', tsltz='1980-10-01 2:00:00.789 +14:00', tstz='1980-10-01 2:00:00.789 +14:00';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 2:00:00.789 Indian/Antananarivo', tsltz='1980-10-01 2:00:00.789 Indian/Antananarivo', tstz='1980-10-01 2:00:00.789 Indian/Antananarivo';
select * from tz_test order by id;
rollback;
update tz_test set ts='1980-10-01', tsltz='1980-10-01', tstz='1980-10-01';
select * from tz_test order by id;
update tz_test set ts='1980-10-01 Asia/Shanghai', tsltz='1980-10-01 Asia/Shanghai', tstz='1980-10-01 Asia/Shanghai';
select * from tz_test order by id;
update tz_test set ts='86400', tsltz='86400', tstz='86400';
select * from tz_test order by id;
rollback;

--test: [er] invalid value
update tz_test set ts='a';
update tz_test set tsltz='bb';
update tz_test set tstz='ccc';
update tz_test set ts=(select d from character_types limit 1); 
update tz_test set tsltz=(select d from character_types limit 1); 
update tz_test set tstz=(select d from character_types limit 1); 

--test: implicit conversion from character string types to ts types
update tz_test set ts=(select a from character_types where id=1), tsltz=(select a from character_types where id=1), tstz=(select a from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select b from character_types where id=1), tsltz=(select b from character_types where id=1), tstz=(select b from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select c from character_types where id=1), tsltz=(select c from character_types where id=1), tstz=(select c from character_types where id=1);
select * from tz_test order by id;
update tz_test set ts=(select e from character_types where id=1), tsltz=(select e from character_types where id=1), tstz=(select e from character_types where id=1);
select * from tz_test order by id;
rollback;

update tz_test set ts=(select a from character_types where id=2), tsltz=(select a from character_types where id=2), tstz=(select a from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=2), tsltz=(select b from character_types where id=2), tstz=(select b from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=2), tsltz=(select c from character_types where id=2), tstz=(select c from character_types where id=2);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=2), tsltz=(select e from character_types where id=2), tstz=(select e from character_types where id=2);
select * from tz_test order by id; 
rollback;

update tz_test set ts=(select a from character_types where id=3), tsltz=(select a from character_types where id=3), tstz=(select a from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=3), tsltz=(select b from character_types where id=3), tstz=(select b from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=3), tsltz=(select c from character_types where id=3), tstz=(select c from character_types where id=3);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=3), tsltz=(select e from character_types where id=3), tstz=(select e from character_types where id=3);
select * from tz_test order by id; 
rollback;

update tz_test set ts=(select a from character_types where id=4), tsltz=(select a from character_types where id=4), tstz=(select a from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select b from character_types where id=4), tsltz=(select b from character_types where id=4), tstz=(select b from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select c from character_types where id=4), tsltz=(select c from character_types where id=4), tstz=(select c from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ts=(select e from character_types where id=4), tsltz=(select e from character_types where id=4), tstz=(select e from character_types where id=4);
select * from tz_test order by id; 
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
