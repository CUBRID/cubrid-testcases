set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_tsltz2 timestampltz,
    c_tstz1 timestamptz, c_tstz2 timestamptz, primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_tsltz2);

insert into tztest values(1,'abcd',timestampltz'1990-1-1 12:00:00 AM +9:00',timestampltz'2000-10-1 12:00:00 AM +9:00',
     timestamptz'1990-1-1 12:00:00 AM +9:00', timestamptz'2000-10-1 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-2 12:00:00 AM +9:00',timestampltz'2000-10-2 12:00:00 AM +9:00',
     timestamptz'1990-1-2 12:00:00 AM +9:00', timestamptz'2000-10-2 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-3 12:00:00 AM +9:00',timestampltz'2000-10-3 12:00:00 AM +9:00',
     timestamptz'1990-1-3 12:00:00 AM +9:00', timestamptz'2000-10-3 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-4 12:00:00 AM +9:00',timestampltz'2000-10-4 12:00:00 AM +9:00',
     timestamptz'1990-1-4 12:00:00 AM +9:00', timestamptz'2000-10-4 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-5 12:00:00 AM +9:00',timestampltz'2000-10-5 12:00:00 AM +9:00',
     timestamptz'1990-1-5 12:00:00 AM +9:00', timestamptz'2000-10-5 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-6 12:00:00 AM +9:00',timestampltz'2000-10-6 12:00:00 AM +9:00',
     timestamptz'1990-1-6 12:00:00 AM +9:00', timestamptz'2000-10-6 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-7 12:00:00 AM +9:00',timestampltz'2000-10-7 12:00:00 AM +9:00',
     timestamptz'1990-1-7 12:00:00 AM +9:00', timestamptz'2000-10-7 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-8 12:00:00 AM +9:00',timestampltz'2000-10-8 12:00:00 AM +9:00',
     timestamptz'1990-1-8 12:00:00 AM +9:00', timestamptz'2000-10-8 12:00:00 AM +9:00');

insert into tztest select 2,null,addtime(c_tsltz1,time'0:01:00'),addtime(c_tsltz2,time'0:00:01'),
  addtime(c_tstz1,time'0:01:00'),addtime(c_tstz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_tsltz1,time'0:02:01'),addtime(c_tsltz2,time'0:01:00'),
  addtime(c_tstz1,time'0:02:01'),addtime(c_tstz2,time'0:01:00') from tztest;
insert into tztest select 4,null,addtime(c_tsltz1,time'0:03:10'),addtime(c_tsltz2,time'0:00:30'),
  addtime(c_tstz1,time'0:03:10'),addtime(c_tstz2,time'0:00:30') from tztest;
insert into tztest select 5,null,addtime(c_tsltz1,time'1:04:01'),addtime(c_tsltz2,time'0:05:04'),
   addtime(c_tstz1,time'1:04:01'),addtime(c_tstz2,time'0:05:04')  from tztest;
insert into tztest select 6,null,addtime(c_tsltz1,time'2:04:10'),addtime(c_tsltz2,time'0:06:10'),
   addtime(c_tstz1,time'2:04:10'),addtime(c_tstz2,time'0:06:10') from tztest;
--++++++++++++++++++Test Case - timestampltz+++++++++++++++++++++++++++++++++++++++++++++
select c_tsltz1,adddate(c_tsltz1, INTERVAL 13 HOUR) from tztest where id =1 and c_tsltz1=timestampltz'12:00:00 AM 01/05/1990 +9:00';
select c_tsltz1,adddate(c_tsltz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and c_tsltz1=timestampltz'12:00:00 AM 01/04/1990 +9:00';
select c_tsltz1,c_tsltz2,adddate(c_tsltz1, INTERVAL EXTRACT(hour from c_tsltz2) HOUR) as result from tztest where id =1 and day(c_tsltz2)=8;

select c_tsltz1,addtime(c_tsltz1, time'13:59:1') from tztest where id=2 and c_tsltz1=timestampltz'12:01:00 AM 01/04/1990 Asia/Seoul';
select c_tsltz1,addtime(c_tsltz1, time'23:59:1') from tztest where c_tsltz1=timestampltz'03:11:12 AM 01/08/1990 Asia/Seoul';
update tztest set c_tsltz2=addtime(c_tsltz2,time'12:00:01') where c_tsltz2=timestampltz'12:12:15 AM 10/08/2000 Asia/Seoul';
select c_tsltz1,c_tsltz2,addtime(c_tsltz1, c_tsltz2 ) from tztest where c_tsltz2=timestampltz'12:12:16 PM 10/08/2000 Asia/Seoul';
select c_tsltz1,c_tsltz2,addtime(c_tsltz1, cast(c_tsltz2 as time) ) from tztest where c_tsltz2=timestampltz'12:12:16 PM 10/08/2000 +9:00';
select c_tsltz1,c_tsltz2,addtime(c_tsltz1, cast(c_tsltz2 as timestamp) ) from tztest where c_tsltz2=timestampltz'12:12:16 PM 10/08/2000 +9:00';
select c_tsltz1,c_tsltz2,addtime(c_tsltz1, cast(c_tsltz2 as timestamptz) ) from tztest where c_tsltz2=timestampltz'12:12:16 PM 10/08/2000 +9:00';
--CUBRIDSUS-17552
--select c_tsltz1,c_tsltz2,addtime(c_tsltz1, cast(c_tsltz2 as string) ) from tztest where c_tsltz2=timestampltz'12:12:16 PM 10/08/2000 +9:00';

-- substract to February
update tztest set c_tsltz1=timestampltz'1990-4-30 12:00:00 PM +9:00' where id=1 and c_tsltz1=timestampltz'1990-1-8 12:00:00 AM +9:00';
select add_months(c_tsltz1, 11),add_months(c_tsltz1, -2) from tztest where c_tsltz1=timestampltz'1990-4-30 12:00:00 PM +9:00';
select c_tsltz1,c_tsltz2,add_months(c_tsltz1, EXTRACT(month from c_tsltz2 ) ) from tztest where id=2 and c_tsltz2='12:00:01 AM 10/01/2000 +9:00';

select date(c_tsltz1) from tztest where MONTH(c_tsltz1)=4;

update tztest set c_tsltz1=timestampltz'1990-5-30 12:00:00 PM +9:00' where id=1 and c_tsltz1=timestampltz'1990-1-7 12:00:00 AM +9:00';
select c_tsltz1,datediff(c_tsltz1,'1991-03-02') from tztest where MONTH(c_tsltz1)=5;
select c_tsltz1,c_tsltz2,datediff(c_tsltz1,c_tsltz2) from tztest where MONTH(c_tsltz1)=5;
select c_tsltz1,c_tsltz2,datediff(c_tsltz1,cast(c_tsltz2 as datetimetz)) from tztest where MONTH(c_tsltz1)=5;
update tztest set c_tsltz2=null where id=3 and c_tsltz2=timestampltz'12:01:01 AM 10/07/2000 Asia/Seoul';
select datediff(c_tsltz1, c_tsltz2) from tztest where  c_tsltz2 is null;

select c_tsltz1,subdate(c_tsltz1, INTERVAL 10 HOUR) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' ;
select c_tsltz1,subdate(c_tsltz1, -10) from tztest where id=1 and date(c_tsltz1) > '01/06/1990'  order by 1;
select c_tsltz1,subdate(c_tsltz1, INTERVAL -10 HOUR) from tztest where id =1 and date(c_tsltz1) > '01/06/1990'  order by 1;
select c_tsltz1,subdate(c_tsltz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,subdate(c_tsltz1, INTERVAL EXTRACT(hour from c_tsltz2) HOUR) from tztest where id =1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,subdate(c_tsltz1, INTERVAL EXTRACT(hour from c_tsltz2) HOUR) from tztest where c_tsltz2 is null order by 1; 

select c_tsltz1,day(c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,dayofweek(c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,dayofyear(c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;

select c_tsltz1,extract (MONTH FROM c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,HOUR(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,HOUR(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;
select c_tsltz1,last_day(c_tsltz1),c_tsltz2,last_day(c_tsltz2) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,last_day(c_tsltz1),c_tsltz2,last_day(c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,MINUTE(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,MINUTE(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;
select c_tsltz1,MONTH(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,MONTH(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,c_tsltz2,months_between(c_tsltz1,c_tsltz2) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,months_between(c_tsltz1,cast(c_tsltz2 as timestamp) ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,months_between(c_tsltz1,cast(c_tsltz2 as datetimeltz)) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,months_between(c_tsltz1,cast(c_tsltz2 as date) ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,months_between(c_tsltz1,cast(c_tsltz1 as datetimeltz) ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,months_between(c_tsltz1,c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,QUARTER(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,QUARTER(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;
--February
select c_tsltz1, round(c_tsltz1), round(c_tsltz1,'yy'), round(c_tsltz1,'hh'), round(c_tsltz1,'day') from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;

select c_tsltz1,second(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,second(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,time(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1, time(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;
select c_tsltz1,time_to_sec(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,time_to_sec(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,TIMEDIFF(addtime(c_tsltz1,time'1:00:00'),c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;  
select c_tsltz1,TIMEDIFF(c_tsltz1,cast(c_tsltz2 as timestamp) ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TIMEDIFF(cast(c_tsltz1 as date),cast(c_tsltz1 as date) ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TIMEDIFF(c_tsltz1,c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,timestamp(c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,c_tsltz2,timestamp(c_tsltz1, c_tsltz2) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,timestamp(c_tsltz1, '12:00:00') from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,timestamp(c_tsltz1, c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,TO_DAYS(c_tsltz1) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TO_DAYS(c_tsltz2) from tztest where c_tsltz2 is null order by 1;
--CUBRIDSUS-17527
--select c_tsltz1,TRUNC(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TRUNC(c_tsltz1,'q' ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TRUNC(c_tsltz1,'dd' ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,TRUNC(c_tsltz2) from tztest where c_tsltz2 is null order by 1;

SELECT c_tsltz1,UNIX_TIMESTAMP(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,UNIX_TIMESTAMP(c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,week(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,week(c_tsltz1, 0 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,week(c_tsltz1, 2 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,week(c_tsltz2) from tztest where c_tsltz2 is null order by 1;

select c_tsltz1,weekday(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,weekday(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;
select c_tsltz1,year(c_tsltz1 ) from tztest where id=1 and date(c_tsltz1) > '01/06/1990' order by 1;
select c_tsltz1,year(c_tsltz2 ) from tztest where c_tsltz2 is null order by 1;

--+++++++++Test Case - timestamptz++++++++++++++++++++++++++++++++++++++++
select c_tstz1,adddate(c_tstz1, INTERVAL 13 HOUR) from tztest where id =1 and c_tstz1=timestampltz'12:00:00 AM 01/05/1990 +9:00' order by 1;
select c_tstz1,adddate(c_tstz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and c_tstz1=timestampltz'12:00:00 AM 01/04/1990 +9:00' order by 1;
select c_tstz1,c_tstz2,adddate(c_tstz1, INTERVAL EXTRACT(hour from c_tstz2) HOUR) as result from tztest where id =1 and day(c_tstz2)=8 order by 1;

select c_tstz1,addtime(c_tstz1, time'13:59:1') from tztest where id=2 and c_tstz1=timestampltz'12:01:00 AM 01/04/1990 Asia/Seoul' order by 1;
select c_tstz1,addtime(c_tstz1, time'23:59:1') from tztest where c_tstz1=timestampltz'03:11:12 AM 01/08/1990 Asia/Seoul' order by 1;
update tztest set c_tstz2=addtime(c_tstz2,time'12:00:01') where c_tstz2=timestampltz'12:12:15 AM 10/08/2000 Asia/Seoul';
select c_tstz1,c_tstz2,addtime(c_tstz1, c_tstz2 ) from tztest where c_tstz2=timestampltz'12:12:16 PM 10/08/2000 Asia/Seoul' order by 1;
select c_tstz1,c_tstz2,addtime(c_tstz1, cast(c_tstz2 as time) ) from tztest where c_tstz2=timestampltz'12:12:16 PM 10/08/2000 +9:00' order by 1;
select c_tstz1,c_tstz2,addtime(c_tstz1, cast(c_tstz2 as timestamp) ) from tztest where c_tstz2=timestampltz'12:12:16 PM 10/08/2000 +9:00' order by 1;
select c_tstz1,c_tstz2,addtime(c_tstz1, cast(c_tstz2 as timestamptz) ) from tztest where c_tstz2=timestampltz'12:12:16 PM 10/08/2000 +9:00' order by 1;
--CUBRIDSUS-17552
--select c_tstz1,c_tstz2,addtime(c_tstz1, cast(c_tstz2 as string) ) from tztest where c_tstz2=timestampltz'12:12:16 PM 10/08/2000 +9:00';

-- substract to February
update tztest set c_tstz1=timestampltz'1990-4-30 12:00:00 PM +9:00' where id=1 and c_tstz1=timestampltz'1990-1-8 12:00:00 AM +9:00';
select add_months(c_tstz1, 11),add_months(c_tstz1, -2) from tztest where c_tstz1=timestampltz'1990-4-30 12:00:00 PM +9:00' order by 1;
select c_tstz1,c_tstz2,add_months(c_tstz1, EXTRACT(month from c_tstz2 ) ) from tztest where id=2 and c_tstz2='12:00:01 AM 10/01/2000 +9:00' order by 1;

select date(c_tstz1) from tztest where MONTH(c_tstz1)=4 order by 1;

update tztest set c_tstz1=timestamptz'1990-5-30 12:00:00 PM +9:00' where id=1 and c_tstz1=timestampltz'1990-1-7 12:00:00 AM +9:00';
select c_tstz1,datediff(c_tstz1,'1991-03-02') from tztest where MONTH(c_tstz1)=5 order by 1;
select c_tstz1,c_tstz2,datediff(c_tstz1,c_tstz2) from tztest where MONTH(c_tstz1)=5 order by 1;
select c_tstz1,c_tstz2,datediff(c_tstz1,cast(c_tstz2 as datetimetz)) from tztest where MONTH(c_tstz1)=5 order by 1;
update tztest set c_tstz2=null where id=3 and c_tstz2=timestamptz'12:01:01 AM 10/07/2000 Asia/Seoul';
select datediff(c_tstz1, c_tstz2) from tztest where  c_tstz2 is null order by 1;

select c_tstz1,subdate(c_tstz1, INTERVAL 10 HOUR) from tztest where id=1 and date(c_tstz1) > '01/06/1990'  order by 1;
select c_tstz1,subdate(c_tstz1, -10) from tztest where id=1 and date(c_tstz1) > '01/06/1990'  order by 1;
select c_tstz1,subdate(c_tstz1, INTERVAL -10 HOUR) from tztest where id =1 and date(c_tstz1) > '01/06/1990'  order by 1;
select c_tstz1,subdate(c_tstz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,subdate(c_tstz1, INTERVAL EXTRACT(hour from c_tstz2) HOUR) from tztest where id =1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,subdate(c_tstz1, INTERVAL EXTRACT(hour from c_tstz2) HOUR) from tztest where c_tstz2 is null order by 1; 

select c_tstz1,day(c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,dayofweek(c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,dayofyear(c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;

select c_tstz1,extract (MONTH FROM c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,HOUR(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,HOUR(c_tstz2 ) from tztest where c_tstz2 is null order by 1;
select c_tstz1,last_day(c_tstz1),c_tstz2,last_day(c_tstz2) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,last_day(c_tstz1),c_tstz2,last_day(c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,MINUTE(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,MINUTE(c_tstz2 ) from tztest where c_tstz2 is null order by 1;
select c_tstz1,MONTH(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,MONTH(c_tstz2 ) from tztest where c_tstz2 is null order by 1;

select c_tstz1,c_tstz2,months_between(c_tstz1,c_tstz2) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,c_tstz2,months_between(c_tstz1,cast(c_tstz2 as timestamp) ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,c_tstz2,months_between(c_tstz1,cast(c_tstz2 as datetimeltz)) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,c_tstz2,months_between(c_tstz1,cast(c_tstz2 as date) ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,c_tstz2,months_between(c_tstz1,cast(c_tstz1 as datetimeltz) ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,c_tstz2,months_between(c_tstz1,c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,QUARTER(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,QUARTER(c_tstz2 ) from tztest where c_tstz2 is null order by 1;
--February
select c_tstz1, round(c_tstz1), round(c_tstz1,'yy'), round(c_tstz1,'hh'), round(c_tstz1,'day') from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;

select c_tstz1,second(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,second(c_tstz2 ) from tztest where c_tstz2 is null order by 1;

select c_tstz1,time(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1, time(c_tstz2 ) from tztest where c_tstz2 is null order by 1;
select c_tstz1,time_to_sec(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,time_to_sec(c_tstz2 ) from tztest where c_tstz2 is null order by 1;

select c_tstz1,TIMEDIFF(addtime(c_tstz1,time'1:00:00'),c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;  
select c_tstz1,TIMEDIFF(c_tstz1,cast(c_tstz2 as timestamp) ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TIMEDIFF(cast(c_tstz1 as date),cast(c_tstz1 as date) ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TIMEDIFF(c_tstz1,c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,timestamp(c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,timestamp(c_tstz1, c_tstz2) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,timestamp(c_tstz1, '12:00:00') from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,timestamp(c_tstz1, c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,TO_DAYS(c_tstz1) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TO_DAYS(c_tstz2) from tztest where c_tstz2 is null order by 1;
--CUBRIDSUS-17527
--select c_tstz1,TRUNC(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TRUNC(c_tstz1,'q' ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TRUNC(c_tstz1,'dd' ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,TRUNC(c_tstz2) from tztest where c_tstz2 is null order by 1;

SELECT c_tstz1,UNIX_TIMESTAMP(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,UNIX_TIMESTAMP(c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,week(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,week(c_tstz1, 0 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,week(c_tstz1, 2 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,week(c_tstz2) from tztest where c_tstz2 is null order by 1;

select c_tstz1,weekday(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,weekday(c_tstz2 ) from tztest where c_tstz2 is null order by 1;
select c_tstz1,year(c_tstz1 ) from tztest where id=1 and date(c_tstz1) > '01/06/1990' order by 1;
select c_tstz1,year(c_tstz2 ) from tztest where c_tstz2 is null order by 1;

drop table tztest;
