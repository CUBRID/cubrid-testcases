--test join with datetime with or columns

drop table if exists tz_test1, tz_test2;

create table tz_test1(
	id int primary key auto_increment, 
	dt datetime,
	dtltz datetime with local time zone,
	dttz datetime with time zone
);
create index idx1 on tz_test1(dtltz);

create table tz_test2(
        id int primary key auto_increment, 
        dt datetime,
        dtltz datetime with local time zone,
        dttz datetime with time zone
);
create index idx2 on tz_test2(dttz);
create index idx3 on tz_test2(dt, dtltz);

set timezone '+5:00';
insert into tz_test1(dt, dtltz, dttz) values(datetimetz'1984-11-22 11:11:11.999', datetimetz'1984-11-22 11:11:11.999', datetimetz'1984-11-22 11:11:11.999');
insert into tz_test1(dt, dtltz, dttz) values(datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00');
insert into tz_test1(dt, dtltz, dttz) values(datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00');
insert into tz_test1(dt, dtltz, dttz) values(datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul', datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul', datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul');
insert into tz_test1(dt, dtltz, dttz) values(datetimetz'2005-03-12 19:34:56.999 America/Argentina/Catamarca', datetimetz'2005-03-12 19:34:56.999 America/Argentina/Catamarca', datetimetz'2005-03-12 19:34:56.999 America/Argentina/Catamarca');


insert into tz_test2(dt, dtltz, dttz) values(datetimetz'1984-11-22 11:11:11.999', datetimetz'1984-11-22 11:11:11.999', datetimetz'1984-11-22 11:11:11.999');
insert into tz_test2(dt, dtltz, dttz) values(datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00', datetimetz'1985-10-11 8:8:8.999 +3:00');
insert into tz_test2(dt, dtltz, dttz) values(datetimetz'2005-03-12 19:34:57.999 Africa/Maseru', datetimetz'2005-03-12 19:34:57.999 Africa/Maseru', datetimetz'2005-03-12 19:34:57.999 Africa/Maseru');
insert into tz_test2(dt, dtltz, dttz) values(datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul', datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul', datetimetz'1990-08-22 15:00:45.999 Europe/Istanbul');
insert into tz_test2(dt, dtltz, dttz) values(datetimetz'1990-08-22 15:00:45.999 Europe/Athens', datetimetz'1990-08-22 15:00:45.999 Europe/Athens', datetimetz'1990-08-22 15:00:45.999 Europe/Athens');

set timezone 'Asia/Seoul';

--test: inner join, dt & dt
select * from tz_test1 t1, tz_test2 t2 where t1.dt=t2.dt order by t1.id,t2.id;
--test: inner join, dtltz & dtltz
select t2.id, t1.dtltz, t2.dtltz, t1.dttz from tz_test1 t1 inner join tz_test2 t2 on t1.dtltz=t2.dtltz order by 1;
--test: inner join, dttz & dttz
select t1.id, t2.id, t2.dttz, t1.dttz, t1.dt aa, t2.dtltz bb from tz_test1 t1, tz_test2 t2 where t1.dttz=t2.dttz and t2.dttz < datetimetz'2000-12-1 00:00:00.999' order by 1,2;

--test: left outer join, dt & dtltz
select * from tz_test1 t1 left outer join tz_test2 t2 on t1.dt=t2.dtltz order by 1;
--test: left outer join, dttz & dtltz
select t1.id, t1.dt, t2.dttz, t1.dtltz, t2.dtltz, t2.id from tz_test2 t2 left outer join tz_test1 t1 on t1.dtltz=t2.dttz where t2.dtltz > datetimetz'1990-05-01 13:14:15.999 -10:00' order by t2.dttz, t1.id, t2.id;
--test: left outer join, dttz & dttz
select t2.id, t1.dttz, t2.dttz, t1.dtltz, t2.dt from tz_test1 t1 left outer join tz_test2 t2 on t2.dttz=t1.dttz where t1.dtltz < datetimetz'1990-08-22 15:00:45.999 Europe/Kaliningrad' order by 1, 2, 4, 5;

--test: right outer join, dtltz & dtltz
select * from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dtltz order by 1, 2, 3, 4, 5;
--test: right outer join, dttz & dt
select t2.id, t1.dttz, t2.dt, t1.dt, t2.dtltz from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dtltz where year(t1.dttz) < 2010 order by t2.id, t1.dttz, t2.dt, t1.dt, t2.dtltz;

--test: mix
select t1.id, t1.dtltz, t2.id, t2.dttz, t3.dttz, t1.dt, t2.dtltz, t3.dtltz from tz_test1 t1 right outer join tz_test2 t2 on t1.dtltz=t2.dttz inner join tz_test1 t3 on t2.dttz=t3.dttz order by 1,3,4, 5, 6, 7, 2;

--test: multi table update
update tz_test1 t1 left outer join tz_test2 t2 on t1.dt=t2.dt and t1.dtltz=t2.dtltz and t1.dttz=t2.dttz set t1.dt=t2.dt+1, t2.dtltz=t1.dttz-10, t1.dttz=t1.dt-1;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;

--test: multi table delete
delete t1, t2 from tz_test1 t1, tz_test2 t2 where t1.dtltz=t2.dttz and t1.dtltz=t2.dt and hour(t2.dtltz)=15;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;


drop table if exists tz_test1, tz_test2;

set timezone 'Asia/Seoul';
