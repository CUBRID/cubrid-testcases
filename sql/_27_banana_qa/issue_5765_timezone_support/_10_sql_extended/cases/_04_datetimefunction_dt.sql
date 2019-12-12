set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_dtltz1 datetimeltz, c_dtltz2 datetimeltz,
    c_dttz1 datetimetz, c_dttz2 datetimetz, primary key (id,c_dtltz1));

create unique index idx_tsltz on tztest(c_dtltz2);

insert into tztest values(1,'abcd',datetimeltz'1990-1-1 12:00:00 AM +9:00',datetimeltz'2000-10-1 12:00:00 AM +9:00',
     datetimetz'1990-1-1 12:00:00 AM +9:00', datetimetz'2000-10-1 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-2 12:00:00 AM +9:00',datetimeltz'2000-10-2 12:00:00 AM +9:00',
     datetimetz'1990-1-2 12:00:00 AM +9:00', datetimetz'2000-10-2 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-3 12:00:00 AM +9:00',datetimeltz'2000-10-3 12:00:00 AM +9:00',
     datetimetz'1990-1-3 12:00:00 AM +9:00', datetimetz'2000-10-3 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-4 12:00:00 AM +9:00',datetimeltz'2000-10-4 12:00:00 AM +9:00',
     datetimetz'1990-1-4 12:00:00 AM +9:00', datetimetz'2000-10-4 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-5 12:00:00 AM +9:00',datetimeltz'2000-10-5 12:00:00 AM +9:00',
     datetimetz'1990-1-5 12:00:00 AM +9:00', datetimetz'2000-10-5 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-6 12:00:00 AM +9:00',datetimeltz'2000-10-6 12:00:00 AM +9:00',
     datetimetz'1990-1-6 12:00:00 AM +9:00', datetimetz'2000-10-6 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-7 12:00:00 AM +9:00',datetimeltz'2000-10-7 12:00:00 AM +9:00',
     datetimetz'1990-1-7 12:00:00 AM +9:00', datetimetz'2000-10-7 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',datetimeltz'1990-1-8 12:00:00 AM +9:00',datetimeltz'2000-10-8 12:00:00 AM +9:00',
     datetimetz'1990-1-8 12:00:00 AM +9:00', datetimetz'2000-10-8 12:00:00 AM +9:00');

insert into tztest select 2,null,addtime(c_dtltz1,time'0:01:00'),addtime(c_dtltz2,time'0:00:01'),
  addtime(c_dttz1,time'0:01:00'),addtime(c_dttz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_dtltz1,time'0:02:01'),addtime(c_dtltz2,time'0:01:00'),
  addtime(c_dttz1,time'0:02:01'),addtime(c_dttz2,time'0:01:00') from tztest;
insert into tztest select 4,null,addtime(c_dtltz1,time'0:03:10'),addtime(c_dtltz2,time'0:00:30'),
  addtime(c_dttz1,time'0:03:10'),addtime(c_dttz2,time'0:00:30') from tztest;
insert into tztest select 5,null,addtime(c_dtltz1,time'1:04:01'),addtime(c_dtltz2,time'0:05:04'),
   addtime(c_dttz1,time'1:04:01'),addtime(c_dttz2,time'0:05:04')  from tztest;
insert into tztest select 6,null,addtime(c_dtltz1,time'2:04:10'),addtime(c_dtltz2,time'0:06:10'),
   addtime(c_dttz1,time'2:04:10'),addtime(c_dttz2,time'0:06:10') from tztest;
--++++++++++++++++++Test Case - datetimeltz+++++++++++++++++++++++++++++++++++++++++++++
select c_dtltz1,adddate(c_dtltz1, INTERVAL 13 HOUR) from tztest where id =1 and c_dtltz1=datetimeltz'12:00:00 AM 01/05/1990 +9:00';
select c_dtltz1,adddate(c_dtltz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and c_dtltz1=datetimeltz'12:00:00 AM 01/04/1990 +9:00' order by 1;
select c_dtltz1,c_dtltz2,adddate(c_dtltz1, INTERVAL EXTRACT(hour from c_dtltz2) HOUR) as result from tztest where id =1 and day(c_dtltz2)=8;

select c_dtltz1,addtime(c_dtltz1, time'13:59:1') from tztest where id=2 and c_dtltz1=datetimeltz'12:01:00 AM 01/04/1990 Asia/Seoul';
select c_dtltz1,addtime(c_dtltz1, time'23:59:1') from tztest where c_dtltz1=datetimeltz'03:11:12 AM 01/08/1990 Asia/Seoul';
update tztest set c_dtltz2=addtime(c_dtltz2,time'12:00:01') where c_dtltz2=datetimeltz'12:12:15 AM 10/08/2000 Asia/Seoul';
select c_dtltz1,c_dtltz2,addtime(c_dtltz1, c_dtltz2 ) from tztest where c_dtltz2=datetimeltz'12:12:16 PM 10/08/2000 Asia/Seoul';
select c_dtltz1,c_dtltz2,addtime(c_dtltz1, cast(c_dtltz2 as time) ) from tztest where c_dtltz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
select c_dtltz1,c_dtltz2,addtime(c_dtltz1, cast(c_dtltz2 as timestamp) ) from tztest where c_dtltz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
select c_dtltz1,c_dtltz2,addtime(c_dtltz1, cast(c_dtltz2 as timestamptz) ) from tztest where c_dtltz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
--CUBRIDSUS-17552
--select c_dtltz1,c_dtltz2,addtime(c_dtltz1, cast(c_dtltz2 as string) ) from tztest where c_dtltz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';

-- substract to February
update tztest set c_dtltz1=datetimeltz'1990-4-30 12:00:00 PM +9:00' where id=1 and c_dtltz1=datetimeltz'1990-1-8 12:00:00 AM +9:00';
select add_months(c_dtltz1, 11),add_months(c_dtltz1, -2) from tztest where c_dtltz1=datetimeltz'1990-4-30 12:00:00 PM +9:00';
select c_dtltz1,c_dtltz2,add_months(c_dtltz1, EXTRACT(month from c_dtltz2 ) ) from tztest where id=2 and c_dtltz2='12:00:01 AM 10/01/2000 +9:00';

select date(c_dtltz1) from tztest where MONTH(c_dtltz1)=4;

update tztest set c_dtltz1=timestampltz'1990-5-30 12:00:00 PM +9:00' where id=1 and c_dtltz1=timestampltz'1990-1-7 12:00:00 AM +9:00';
select c_dtltz1,datediff(c_dtltz1,'1991-03-02') from tztest where MONTH(c_dtltz1)=5;
select c_dtltz1,c_dtltz2,datediff(c_dtltz1,c_dtltz2) from tztest where MONTH(c_dtltz1)=5;
select c_dtltz1,c_dtltz2,datediff(c_dtltz1,cast(c_dtltz2 as datetimetz)) from tztest where MONTH(c_dtltz1)=5;
update tztest set c_dtltz2=null where id=3 and c_dtltz2=datetimeltz'12:01:01 AM 10/07/2000 Asia/Seoul';
select datediff(c_dtltz1, c_dtltz2) from tztest where  c_dtltz2 is null;

select c_dtltz1,subdate(c_dtltz1, INTERVAL 10 HOUR) from tztest where id=1 and date(c_dtltz1) > '01/06/1990'  order by 1;
select c_dtltz1,subdate(c_dtltz1, -10) from tztest where id=1 and date(c_dtltz1) > '01/06/1990'  order by 1;
select c_dtltz1,subdate(c_dtltz1, INTERVAL -10 HOUR) from tztest where id =1 and date(c_dtltz1) > '01/06/1990'  order by 1;
select c_dtltz1,subdate(c_dtltz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,subdate(c_dtltz1, INTERVAL EXTRACT(hour from c_dtltz2) HOUR) as result from tztest where id =1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,subdate(c_dtltz1, INTERVAL EXTRACT(hour from c_dtltz2) HOUR) from tztest where c_dtltz2 is null order by 1; 

select c_dtltz1,day(c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,dayofweek(c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,dayofyear(c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;

select c_dtltz1,extract(MONTH FROM c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,extract(MILLISECOND FROM c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,HOUR(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,HOUR(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;
select c_dtltz1,last_day(c_dtltz1),c_dtltz2,last_day(c_dtltz2) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,last_day(c_dtltz1),c_dtltz2,last_day(c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,MINUTE(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,MINUTE(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;
select c_dtltz1,MONTH(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,MONTH(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,c_dtltz2,months_between(c_dtltz1,c_dtltz2) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,months_between(c_dtltz1,cast(c_dtltz2 as timestamp) ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,months_between(c_dtltz1,cast(c_dtltz2 as datetimeltz)) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,months_between(c_dtltz1,cast(c_dtltz2 as date) ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,months_between(c_dtltz1,cast(c_dtltz1 as datetimeltz) ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,months_between(c_dtltz1,c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,QUARTER(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,QUARTER(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;
--February
select c_dtltz1, round(c_dtltz1), round(c_dtltz1,'yy'), round(c_dtltz1,'hh'), round(c_dtltz1,'day') from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;

select c_dtltz1,second(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,second(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,time(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1, time(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;
select c_dtltz1,time_to_sec(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,time_to_sec(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,TIMEDIFF(addtime(c_dtltz1,time'1:00:00'),c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;  
select c_dtltz1,TIMEDIFF(c_dtltz1,cast(c_dtltz2 as timestamp) ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,TIMEDIFF(cast(c_dtltz1 as date),cast(c_dtltz1 as date) ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,TIMEDIFF(c_dtltz1,c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,timestamp(c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,c_dtltz2,timestamp(c_dtltz1, c_dtltz2) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,timestamp(c_dtltz1, '12:00:00') from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,timestamp(c_dtltz1, c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,TO_DAYS(c_dtltz1) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,TO_DAYS(c_dtltz2) from tztest where c_dtltz2 is null order by 1;

--CUBRIDSUS-17527
--select c_dtltz1,TRUNC(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990';
select c_dtltz1,TRUNC(c_dtltz1,'q' ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,TRUNC(c_dtltz1,'dd' ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,TRUNC(c_dtltz2) from tztest where c_dtltz2 is null order by 1;

SELECT c_dtltz1,UNIX_TIMESTAMP(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,UNIX_TIMESTAMP(c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,week(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,week(c_dtltz1, 0 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,week(c_dtltz1, 2 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,week(c_dtltz2) from tztest where c_dtltz2 is null order by 1;

select c_dtltz1,weekday(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,weekday(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;
select c_dtltz1,year(c_dtltz1 ) from tztest where id=1 and date(c_dtltz1) > '01/06/1990' order by 1;
select c_dtltz1,year(c_dtltz2 ) from tztest where c_dtltz2 is null order by 1;

--+++++++++Test Case - datetimetz++++++++++++++++++++++++++++++++++++++++
select c_dttz1,adddate(c_dttz1, INTERVAL 13 HOUR) from tztest where id =1 and c_dttz1=datetimeltz'12:00:00 AM 01/05/1990 +9:00';
select c_dttz1,adddate(c_dttz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and c_dttz1=datetimeltz'12:00:00 AM 01/04/1990 +9:00';
select c_dttz1,c_dttz2,adddate(c_dttz1, INTERVAL EXTRACT(hour from c_dttz2) HOUR) as result from tztest where id =1 and day(c_dttz2)=8;

select c_dttz1,addtime(c_dttz1, time'13:59:1') from tztest where id=2 and c_dttz1=datetimeltz'12:01:00 AM 01/04/1990 Asia/Seoul';
select c_dttz1,addtime(c_dttz1, time'23:59:1') from tztest where c_dttz1=datetimeltz'03:11:12 AM 01/08/1990 Asia/Seoul';
update tztest set c_dttz2=addtime(c_dttz2,time'12:00:01') where c_dttz2=datetimeltz'12:12:15 AM 10/08/2000 Asia/Seoul';
select c_dttz1,c_dttz2,addtime(c_dttz1, c_dttz2 ) from tztest where c_dttz2=datetimeltz'12:12:16 PM 10/08/2000 Asia/Seoul';
select c_dttz1,c_dttz2,addtime(c_dttz1, cast(c_dttz2 as time) ) from tztest where c_dttz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
select c_dttz1,c_dttz2,addtime(c_dttz1, cast(c_dttz2 as timestamp) ) from tztest where c_dttz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
select c_dttz1,c_dttz2,addtime(c_dttz1, cast(c_dttz2 as datetimetz) ) from tztest where c_dttz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';
--CUBRIDSUS-17552
--select c_dttz1,c_dttz2,addtime(c_dttz1, cast(c_dttz2 as string) ) from tztest where c_dttz2=datetimeltz'12:12:16 PM 10/08/2000 +9:00';

-- substract to February
update tztest set c_dttz1=datetimeltz'1990-4-30 12:00:00 PM +9:00' where id=1 and c_dttz1=datetimeltz'1990-1-8 12:00:00 AM +9:00';
select add_months(c_dttz1, 11),add_months(c_dttz1, -2) from tztest where c_dttz1=datetimeltz'1990-4-30 12:00:00 PM +9:00';
select c_dttz1,c_dttz2,add_months(c_dttz1, EXTRACT(month from c_dttz2 ) ) from tztest where id=2 and c_dttz2='12:00:01 AM 10/01/2000 +9:00';

select date(c_dttz1) from tztest where MONTH(c_dttz1)=4;

update tztest set c_dttz1=timestampltz'1990-5-30 12:00:00 PM +9:00' where id=1 and c_dttz1=timestampltz'1990-1-7 12:00:00 AM +9:00';
select c_dttz1,datediff(c_dttz1,'1991-03-02') from tztest where MONTH(c_dttz1)=4;
select c_dttz1,c_dttz2,datediff(c_dttz1,c_dttz2) from tztest where MONTH(c_dttz1)=4;
select c_dttz1,c_dttz2,datediff(c_dttz1,cast(c_dttz2 as datetimetz)) from tztest where MONTH(c_dttz1)=4;
update tztest set c_dttz2=null where id=3 and c_dttz2=datetimetz'12:01:01 AM 10/07/2000 Asia/Seoul';
select datediff(c_dttz1, c_dttz2) from tztest where  c_dttz2 is null;

select c_dttz1,subdate(c_dttz1, INTERVAL 10 HOUR) from tztest where id=1 and date(c_dttz1) > '01/06/1990'  order by 1;
select c_dttz1,subdate(c_dttz1, -10) from tztest where id=1 and date(c_dttz1) > '01/06/1990'  order by 1;
select c_dttz1,subdate(c_dttz1, INTERVAL -10 HOUR) from tztest where id =1 and date(c_dttz1) > '01/06/1990'  order by 1;
select c_dttz1,subdate(c_dttz1, INTERVAL '12 12:12' DAY_MINUTE) from tztest where id =1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,subdate(c_dttz1, INTERVAL EXTRACT(hour from c_dttz2) HOUR) from tztest where id =1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,subdate(c_dttz1, INTERVAL EXTRACT(hour from c_dttz2) HOUR) from tztest where c_dttz2 is null order by 1; 

select c_dttz1,day(c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,dayofweek(c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,dayofyear(c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;

select c_dttz1,extract (MONTH FROM c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,extract(MILLISECOND FROM c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,HOUR(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,HOUR(c_dttz2 ) from tztest where c_dttz2 is null order by 1;
select c_dttz1,last_day(c_dttz1),c_dttz2,last_day(c_dttz2) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,last_day(c_dttz1),c_dttz2,last_day(c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,MINUTE(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,MINUTE(c_dttz2 ) from tztest where c_dttz2 is null order by 1;
select c_dttz1,MONTH(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,MONTH(c_dttz2 ) from tztest where c_dttz2 is null order by 1;

select c_dttz1,c_dttz2,months_between(c_dttz1,c_dttz2) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,c_dttz2,months_between(c_dttz1,cast(c_dttz2 as timestamp) ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,c_dttz2,months_between(c_dttz1,cast(c_dttz2 as datetimeltz)) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,c_dttz2,months_between(c_dttz1,cast(c_dttz2 as date) ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,c_dttz2,months_between(c_dttz1,cast(c_dttz1 as datetimeltz) ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,c_dttz2,months_between(c_dttz1,c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,QUARTER(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,QUARTER(c_dttz2 ) from tztest where c_dttz2 is null order by 1;
--February
select c_dttz1, round(c_dttz1), round(c_dttz1,'yy'), round(c_dttz1,'hh'), round(c_dttz1,'day') from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;

select c_dttz1,second(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,second(c_dttz2 ) from tztest where c_dttz2 is null order by 1;

select c_dttz1,time(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1, time(c_dttz2 ) from tztest where c_dttz2 is null order by 1;
select c_dttz1,time_to_sec(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,time_to_sec(c_dttz2 ) from tztest where c_dttz2 is null order by 1;

select c_dttz1,TIMEDIFF(addtime(c_dttz1,time'1:00:00'),c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;  
select c_dttz1,TIMEDIFF(c_dttz1,cast(c_dttz2 as timestamp) ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,TIMEDIFF(cast(c_dttz1 as date),cast(c_dttz1 as date) ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,TIMEDIFF(c_dttz1,c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,timestamp(c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,timestamp(c_dttz1, c_dttz2) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,timestamp(c_dttz1, '12:00:00') from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,timestamp(c_dttz1, c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,TO_DAYS(c_dttz1) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,TO_DAYS(c_dttz2) from tztest where c_dttz2 is null;
--CUBRIDSUS-17527
--select c_dttz1,TRUNC(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990';
select c_dttz1,TRUNC(c_dttz1,'q' ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,TRUNC(c_dttz1,'dd' ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,TRUNC(c_dttz2) from tztest where c_dttz2 is null order by 1;
--issue TDB
--SELECT c_dttz1,UNIX_TIMESTAMP(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990';
select c_dttz1,UNIX_TIMESTAMP(c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,week(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,week(c_dttz1, 0 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,week(c_dttz1, 2 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,week(c_dttz2) from tztest where c_dttz2 is null order by 1;

select c_dttz1,weekday(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,weekday(c_dttz2 ) from tztest where c_dttz2 is null order by 1;
select c_dttz1,year(c_dttz1 ) from tztest where id=1 and date(c_dttz1) > '01/06/1990' order by 1;
select c_dttz1,year(c_dttz2 ) from tztest where c_dttz2 is null order by 1;

drop table tztest;
