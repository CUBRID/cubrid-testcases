--test join with timestamp with or columns

drop table if exists tz_test1, tz_test2;

create table tz_test1(
	id int primary key auto_increment, 
	ts timestamp,
	tsltz timestamp with local time zone,
	tstz timestamp with time zone
);
create index idx1 on tz_test1(tsltz);

create table tz_test2(
        id int primary key auto_increment, 
        ts timestamp,
        tsltz timestamp with local time zone,
        tstz timestamp with time zone
);
create index idx2 on tz_test2(tstz);
create index idx3 on tz_test2(ts, tsltz);

set timezone '+5:00';
insert into tz_test1(ts, tsltz, tstz) values(timestamptz'1984-11-22 11:11:11', timestamptz'1984-11-22 11:11:11', timestamptz'1984-11-22 11:11:11');
insert into tz_test1(ts, tsltz, tstz) values(timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00');
insert into tz_test1(ts, tsltz, tstz) values(timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00');
insert into tz_test1(ts, tsltz, tstz) values(timestamptz'1990-08-22 15:00:45 Europe/Istanbul', timestamptz'1990-08-22 15:00:45 Europe/Istanbul', timestamptz'1990-08-22 15:00:45 Europe/Istanbul');
insert into tz_test1(ts, tsltz, tstz) values(timestamptz'2005-03-12 19:34:56 America/Argentina/Catamarca', timestamptz'2005-03-12 19:34:56 America/Argentina/Catamarca', timestamptz'2005-03-12 19:34:56 America/Argentina/Catamarca');


insert into tz_test2(ts, tsltz, tstz) values(timestamptz'1984-11-22 11:11:11', timestamptz'1984-11-22 11:11:11', timestamptz'1984-11-22 11:11:11');
insert into tz_test2(ts, tsltz, tstz) values(timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00', timestamptz'1985-10-11 8:8:8 +3:00');
insert into tz_test2(ts, tsltz, tstz) values(timestamptz'2005-03-12 19:34:57 Africa/Maseru', timestamptz'2005-03-12 19:34:57 Africa/Maseru', timestamptz'2005-03-12 19:34:57 Africa/Maseru');
insert into tz_test2(ts, tsltz, tstz) values(timestamptz'1990-08-22 15:00:45 Europe/Istanbul', timestamptz'1990-08-22 15:00:45 Europe/Istanbul', timestamptz'1990-08-22 15:00:45 Europe/Istanbul');
insert into tz_test2(ts, tsltz, tstz) values(timestamptz'1990-08-22 15:00:45 Europe/Athens', timestamptz'1990-08-22 15:00:45 Europe/Athens', timestamptz'1990-08-22 15:00:45 Europe/Athens');

set timezone 'Asia/Seoul';

--test: inner join, ts & ts
select * from tz_test1 t1, tz_test2 t2 where t1.ts=t2.ts order by 1,2,3,4,5,6,7,8;
--test: inner join, tsltz & tsltz
select t2.id, t1.tsltz, t2.tsltz, t1.tstz from tz_test1 t1 inner join tz_test2 t2 on t1.tsltz=t2.tsltz order by 1,2,3,4;
--test: inner join, tstz & tstz
select t1.id, t2.id, t2.tstz, t1.tstz t1_tstz, t1.ts aa, t2.tsltz bb from tz_test1 t1, tz_test2 t2 where t1.tstz=t2.tstz and t2.tstz < timestamptz'2000-12-1 00:00:00' order by 1,3,4,5,6,2;

--test: left outer join, ts & tsltz
select * from tz_test1 t1 left outer join tz_test2 t2 on t1.ts=t2.tsltz order by 1,2,3,4,5,6,7,8;
--test: left outer join, tstz & tsltz
select t1.id, t1.ts, t2.id, t2.tstz, t1.tsltz, t2.tsltz from tz_test2 t2 left outer join tz_test1 t1 on t1.tsltz=t2.tstz where t2.tsltz > timestamptz'1990-05-01 13:14:15 -10:00' order by t2.tstz, t1.id, t2.tsltz, t1.tsltz, t2.id;
--test: left outer join, tstz & tstz
select t2.id, t1.tstz, t2.tstz, t1.tsltz, t2.ts from tz_test1 t1 left outer join tz_test2 t2 on t2.tstz=t1.tstz where t1.tsltz < timestamptz'1990-08-22 15:00:45 Europe/Kaliningrad' order by 1, 2, 4, 5;

--test: right outer join, tsltz & tsltz
select * from tz_test1 t1 right outer join tz_test2 t2 on t1.tsltz=t2.tsltz order by 1, 2, 3, 4, 5;
--test: right outer join, tstz & ts
select t2.id, t1.tstz, t2.ts, t1.ts, t2.tsltz from tz_test1 t1 right outer join tz_test2 t2 on t1.tsltz=t2.tsltz where year(t1.tstz) < 2010 order by 1,2,3,4,5;

--test: mix
select t1.id, t1.tsltz, t2.id , t2.tstz, t3.tstz, t1.ts, t2.tsltz, t3.tsltz from tz_test1 t1 right outer join tz_test2 t2 on t1.tsltz=t2.tstz inner join tz_test1 t3 on t2.tstz=t3.tstz order by t1.id, t1.tsltz, t2.tstz, t3.tstz, t1.ts, t2.tsltz, t3.tsltz,t2.id;

--test: multi table update
update tz_test1 t1 left outer join tz_test2 t2 on t1.ts=t2.ts and t1.tsltz=t2.tsltz and t1.tstz=t2.tstz set t1.ts=t2.ts+1, t2.tsltz=t1.tstz-10, t1.tstz=t1.ts-1;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;

--test: multi table delete
delete t1, t2 from tz_test1 t1, tz_test2 t2 where t1.tsltz=t2.tstz and t1.tsltz=t2.ts and hour(t2.tsltz)=15;
select * from tz_test1 order by 1;
select * from tz_test2 order by 1;


drop table tz_test1, tz_test2;

set timezone 'Asia/Seoul';
