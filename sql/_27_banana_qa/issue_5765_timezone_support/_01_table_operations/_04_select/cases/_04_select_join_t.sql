--test join with time with or columns

drop table if exists tz_test1, tz_test2;

create table tz_test1(
	id int primary key auto_increment, 
	t time,
	dtltz datetime with local time zone,
	dttz datetime with time zone
);
create index idx1 on tz_test1(dtltz);

create table tz_test2(
        id int primary key auto_increment, 
        t time,
        dtltz datetime with local time zone,
        dttz datetime with time zone
);
create index idx2 on tz_test2(dttz);
create index idx3 on tz_test2(t, dtltz);

set timezone '+5:00';
insert into tz_test1(t, dtltz, dttz) values(datetimetz'2111-11-11 11:11:11', datetimetz'2111-11-11 11:11:11', datetimetz'2111-11-11 11:11:11');
insert into tz_test1(t, dtltz, dttz) values(datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00');
insert into tz_test1(t, dtltz, dttz) values(datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00');
insert into tz_test1(t, dtltz, dttz) values(datetimetz'2015-9-17 15:00:45 Africa/Blantyre', datetimetz'2015-9-17 15:00:45 Africa/Blantyre', datetimetz'2015-9-17 15:00:45 Africa/Blantyre');
insert into tz_test1(t, dtltz, dttz) values(datetimetz'2015-9-17 19:34:56 America/Argentina/Catamarca', datetimetz'2015-9-17 19:34:56 America/Argentina/Catamarca', datetimetz'2015-9-17 19:34:56 America/Argentina/Catamarca');


insert into tz_test2(t, dtltz, dttz) values(datetimetz'2111-11-11 11:11:11', datetimetz'2111-11-11 11:11:11', datetimetz'2111-11-11 11:11:11');
insert into tz_test2(t, dtltz, dttz) values(datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00', datetimetz'2015-9-17 8:8:8 +3:00');
insert into tz_test2(t, dtltz, dttz) values(datetimetz'2015-9-17 19:34:57 Africa/Maseru', datetimetz'2015-9-17 19:34:57 Africa/Maseru', datetimetz'2015-9-17 19:34:57 Africa/Maseru');
insert into tz_test2(t, dtltz, dttz) values(datetimetz'2015-9-17 15:00:45 Africa/Blantyre', datetimetz'2015-9-17 15:00:45 Africa/Blantyre', datetimetz'2015-9-17 15:00:45 Africa/Blantyre');
insert into tz_test2(t, dtltz, dttz) values(datetimetz'2015-9-17 15:00:45 Asia/Gaza', datetimetz'2015-9-17 15:00:45 Asia/Gaza', datetimetz'2015-9-17 15:00:45 Asia/Gaza');

set timezone 'Asia/Seoul';

--test: inner join, t & t
select * from tz_test1 t1, tz_test2 t2 where t1.t=t2.t order by t1.id, t2.id;
--test: inner join, dtltz & dtltz
select t2.id, t1.dtltz, t2.dtltz, t1.dttz from tz_test1 t1 inner join tz_test2 t2 on t1.dtltz=t2.dtltz order by 1;
--test: inner join, dttz & dttz
select t1.id, t2.dttz, t1.dttz, t1.t aa, t2.dtltz bb from tz_test1 t1, tz_test2 t2 where t1.dttz=t2.dttz and t2.dttz < datetimetz'2015-9-17 00:00:00' order by 1;

--test: left outer join, t & dtltz
--BUG: CUBRIDSUS-16932, resolved
select * from tz_test1 t1 left outer join tz_test2 t2 on t1.t=t2.dtltz order by 1;
--test: left outer join, dttz & dtltz
select t1.id, t1.t, t2.dttz, t1.dtltz, t2.dtltz from tz_test2 t2 left outer join tz_test1 t1 on t1.dtltz=t2.dttz where t2.dtltz > datetimetz'2015-9-17 13:14:15 -10:00' order by t2.dttz, t1.id;
--test: left outer join, dttz & dttz
select t2.id, t1.dttz, t2.dttz, t1.dtltz, t2.t from tz_test1 t1 left outer join tz_test2 t2 on t2.dttz=t1.dttz where t1.dtltz < datetimetz'2015-9-17 15:00:45 Europe/Kaliningrad' order by 1, 2, 4, 5;

--test: right outer join, dtltz & dtltz
select * from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dtltz order by 1, 2, 3, 4, 5;
--test: right outer join, dttz & t
select t2.id, t1.dttz, t2.t, t1.t, t2.dtltz from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dtltz where hour(t1.dttz) <= 15 order by 1, 2, 3, 4, 5;

--test: mix
select t1.id, t1.dtltz, t2.dttz, t3.dttz, t1.t, t2.dtltz, t3.dtltz from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dttz inner join tz_test1 t3 on t2.dttz=t3.dttz order by 1, 2, 3, 4, 5, 6;

--test: multi table update
update tz_test1 t1 left outer join tz_test2 t2 on t1.t=t2.t and t1.dtltz=t2.dtltz and t1.dttz=t2.dttz set t1.t=t2.t+1, t2.dtltz=t1.dttz-10;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;

--test: multi table delete
set timezone '+9:00';
delete t1, t2 from tz_test1 t1, tz_test2 t2 where t1.dtltz=t2.dttz  and hour(t2.dtltz)=15;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;


drop table tz_test1, tz_test2;

set timezone 'Asia/Seoul';
