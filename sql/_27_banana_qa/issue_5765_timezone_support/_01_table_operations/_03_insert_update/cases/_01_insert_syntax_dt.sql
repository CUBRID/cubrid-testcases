--insert into DATETIME(L)TZ columns without constraints


drop table if exists tz_test;

create table tz_test(
	id int,
	ts datetime,
	tsltz datetime with local time zone,
	tstz datetime with time zone
);


--test: insert ... values, one row
insert into tz_test values (1, datetime'2003-03-30 02:30:00.369', datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 +03:00');
select * from tz_test order by 1;

--test: insert ... values, multiple rows
insert into tz_test values 
	(2, datetime'2003-03-30 02:30:00.369', datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 AM +03:00'),
        (3, datetime'2003-03-30 02:30:00.369', datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 AM -11:00'),
        (4, datetime'2003-03-30 02:30:00.369', datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 PM Asia/Seoul');
select * from tz_test order by 1;

--test: insert ... values, implicit insert
insert into tz_test(id, tsltz, tstz) values (5, datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 AM +06:00'); 
insert into tz_test(id, ts, tstz) values (6, datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 AM -02:00'); 
insert into tz_test(id, ts, tsltz) values (7, datetime'2003-03-30 02:30:00.369', datetimetz'2003-03-30 02:30:00.369 PM');
select * from tz_test order by 1;

--test: insert ... select 
insert into tz_test select * from tz_test where id=5; 
select * from tz_test order by 1;
insert into tz_test select id+100, ts, tsltz, tstz from tz_test where id < 3;
select * from tz_test order by 1;
insert into tz_test(id, tsltz) select 200, datetime'1990-11-11 21:01:23.369';
select * from tz_test order by 1;
insert into tz_test(id, tstz) select id+200, tstz from (select * from tz_test where id in (4, 7));
select * from tz_test order by 1;

--test: insert values + select
insert into tz_test values(300, datetime'1990-11-11 21:01:23.369', select tsltz from tz_test where id=6, select datetimetz'1990-11-11 21:01:23.369 +3:30' from db_class where rownum=1);
select * from tz_test order by 1;

--test: insert ... set
insert into tz_test set id=400, tsltz=datetimeltz'2003-03-30 02:30:00.369', tstz=datetimetz'1990-11-11 21:01:23.369 Europe/Paris';
insert into tz_test set id=401, tstz=(select tstz from tz_test where id=400);
select * from tz_test order by 1;


drop table tz_test;


