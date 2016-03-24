--implicit conversion from character string types to TIME(L)TZ types, in update

autocommit off;

drop table if exists tz_test, character_types;

create table tz_test (id int auto_increment, t time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'20:00:00', datetimeltz'2015-9-17 20:00:00', datetimetz'2015-9-17 20:00:00 Asia/Yakutsk');

create table character_types(id int auto_increment, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('08:00:00 PM', '12:00:01 PM 01/02/2019 +08:00', '08:00:00 PM +09:00', '08:00:00 PM Asia/Seoul'));
insert into character_types(a, b, c, d, e) values('aaa', 'bbb', 'ccc', 3, 2);
insert into character_types(a, b, c, d, e) values('20:00:00', '20:00:00', '20:00:00', 3, 1);
insert into character_types(a, b, c, d, e) values('20:00:00 +9:00', '20:00:00 +9:00', '20:00:00 +9:00', 2, 3);
insert into character_types(a, b, c, d, e) values('20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', 1, 4);
commit;

set timezone '+9:00';
--test: implicit conversion from character string constant values to t types
update tz_test set t='2:00:00', tltz='2015-9-17 2:00:00', ttz='2015-9-17 2:00:00';
select * from tz_test order by id;
update tz_test set t='2:00:00', tltz='2015-9-17 2:00:00 +14:00', ttz='2015-9-17 2:00:00 +14:00';
select * from tz_test order by id;
update tz_test set t='2:00:00', tltz='2015-9-17 2:00:00 -1:00', ttz='2015-9-17 2:00:00 Indian/Antananarivo';
select * from tz_test order by id;
rollback;

update tz_test set t='2:00:00.789', tltz='2:00:00.789', ttz='2:00:00.789';
select * from tz_test order by id;
update tz_test set t='2:00:00.789', tltz='2:00:00.789 +14:00', ttz='2:00:00.789 +14:00';
select * from tz_test order by id;
update tz_test set t='2:00:00.789', tltz='2:00:00.789 Indian/Antananarivo', ttz='2:00:00.789 Indian/Antananarivo';
select * from tz_test order by id;
rollback;
update tz_test set t='1980-10-01', tltz='1980-10-01', ttz='1980-10-01';
select * from tz_test order by id;
update tz_test set t='Asia/Shanghai', tltz='Asia/Shanghai', ttz='Asia/Shanghai';
select * from tz_test order by id;
update tz_test set t='86400', tltz='86400', ttz='86400';
select * from tz_test order by id;
rollback;

--test: [er] invalid value
update tz_test set t='a';
update tz_test set tltz='bb';
update tz_test set ttz='ccc';
update tz_test set t=(select d from character_types limit 1); 
update tz_test set tltz=(select d from character_types limit 1); 
update tz_test set ttz=(select d from character_types limit 1); 

--test: implicit conversion from character string types to t types
update tz_test set t=(select a from character_types where id=1), tltz=(select a from character_types where id=1), ttz=(select a from character_types where id=1);
select * from tz_test order by id;
update tz_test set t=(select b from character_types where id=1), tltz=(select b from character_types where id=1), ttz=(select b from character_types where id=1);
select * from tz_test order by id;
update tz_test set t=(select c from character_types where id=1), tltz=(select c from character_types where id=1), ttz=(select c from character_types where id=1);
select * from tz_test order by id;
update tz_test set t=(select e from character_types where id=1), tltz=(select e from character_types where id=1), ttz=(select e from character_types where id=1);
select * from tz_test order by id;
rollback;

update tz_test set t=(select a from character_types where id=2), tltz=(select a from character_types where id=2), ttz=(select a from character_types where id=2);
select * from tz_test order by id; 
update tz_test set t=(select b from character_types where id=2), tltz=(select b from character_types where id=2), ttz=(select b from character_types where id=2);
select * from tz_test order by id; 
update tz_test set t=(select c from character_types where id=2), tltz=(select c from character_types where id=2), ttz=(select c from character_types where id=2);
select * from tz_test order by id; 
update tz_test set t=(select e from character_types where id=2), tltz=(select e from character_types where id=2), ttz=(select e from character_types where id=2);
select * from tz_test order by id; 
rollback;

update tz_test set tltz=(select a from character_types where id=3), ttz=(select a from character_types where id=3);
select * from tz_test order by id; 
update tz_test set tltz=(select b from character_types where id=3), ttz=(select b from character_types where id=3);
select * from tz_test order by id; 
update tz_test set tltz=(select c from character_types where id=3), ttz=(select c from character_types where id=3);
select * from tz_test order by id; 
update tz_test set tltz=(select e from character_types where id=3), ttz=(select e from character_types where id=3);
select * from tz_test order by id; 
rollback;

update tz_test set ttz=(select a from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ttz=(select b from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ttz=(select c from character_types where id=4);
select * from tz_test order by id; 
update tz_test set ttz=(select e from character_types where id=4);
select * from tz_test order by id; 
rollback;


drop table tz_test, character_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
