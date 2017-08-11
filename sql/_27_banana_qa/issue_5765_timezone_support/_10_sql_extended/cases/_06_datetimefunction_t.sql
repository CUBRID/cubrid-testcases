set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_dtltz1 datetimeltz,
    c_tltz1 datetimeltz, c_tltz2 datetimeltz,
    c_ttz1 datetimetz, c_ttz2 datetimetz, primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_dtltz1);

insert into tztest values(1,'abcd',timestampltz'1990-1-1 12:00:00 AM +9:00',datetimeltz'2000-10-1 12:00:00 AM +9:00',
     datetimeltz'2015-9-17 12:00:01 AM +9:00', datetimeltz'2015-9-17 9:01:00 AM +9:00',datetimetz'2015-9-17 12:00:01 AM +9:00', datetimetz'2015-9-17 9:01:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-2 12:00:00 AM +9:00',datetimeltz'2000-10-2 12:00:00 AM +9:00',
     datetimeltz'2015-9-17 12:00:02 AM +9:00', datetimeltz'2015-9-17 9:02:00 AM +9:00',datetimetz'2015-9-17 12:00:02 AM +9:00', datetimetz'2015-9-17 9:02:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-3 12:00:00 AM +9:00',datetimeltz'2000-10-3 12:00:00 AM +9:00',
     datetimeltz'2015-9-17 12:00:03 AM +9:00', datetimeltz'2015-9-17 9:03:00 AM +9:00',datetimetz'2015-9-17 12:00:03 AM +9:00', datetimetz'2015-9-17 9:03:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-4 12:00:00 AM +9:00',datetimeltz'2000-10-4 12:00:00 AM +9:00',
     datetimeltz'2015-9-17 12:00:04 AM +9:00', datetimeltz'2015-9-17 9:04:00 AM +9:00',datetimetz'2015-9-17 12:00:04 AM +9:00', datetimetz'2015-9-17 9:04:00 AM +9:00');

insert into tztest select 2,null,addtime(c_tsltz1,time'0:01:00'),addtime(c_dtltz1,time'0:00:01'),
  addtime(c_tltz1,time'0:00:01'),addtime(c_tltz2,time'0:00:01'),addtime(c_ttz1,time'0:00:01'),addtime(c_ttz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_tsltz1,time'0:02:01'),addtime(c_dtltz1,time'0:01:00'),
  addtime(c_tltz1,time'0:00:10'),addtime(c_tltz2,time'0:00:10'),addtime(c_ttz1,time'0:00:10'),addtime(c_ttz2,time'0:00:10') from tztest;
insert into tztest select 4,null,addtime(c_tsltz1,time'0:03:10'),addtime(c_dtltz1,time'0:00:30'),
  addtime(c_tltz1,time'0:02:01'),addtime(c_tltz2,time'0:02:01'),addtime(c_ttz1,time'0:02:01'),addtime(c_ttz2,time'0:02:01') from tztest;

--++++++++++++++++++Test Case - timestampltz+++++++++++++++++++++++++++++++++++++++++++++
select c_tltz1,addtime(c_tltz1, time'12:59:1') from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00'; 
--CUBRIDSUS-17532
--select c_tltz1,addtime(c_tltz1, '12:59:1') from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00'; 
select c_tltz1,addtime(c_tltz1, time'23:59:1') from tztest where c_tltz1=datetimetz'2015-9-17 12:00:02 AM +9:00' order by 1,2;

update tztest set c_tltz1=addtime(c_tltz1,time'12:00:01') where c_tltz1=datetimetz'2015-9-17 12:00:02 AM +9:00';
select c_tltz1,c_tltz2,addtime(c_tltz1, c_tltz2 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:00:03 PM +9:00' order by 1,2,3;

select c_tltz1,c_dtltz1,addtime(c_tltz1, c_dtltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,c_dtltz1,addtime(c_tltz1, cast(c_dtltz1 as time) ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,c_dtltz1,addtime(c_tltz1, cast(c_dtltz1 as timestamp) ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,c_dtltz1,addtime(c_tltz1, cast(c_dtltz1 as timestamptz) ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
--CUBRIDSUS-17532
--select c_tltz1,c_dtltz1,addtime(c_tltz1, cast(c_dtltz1 as string) ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
 
update tztest set c_tltz1='8:00:00 PM +9:00' where c_tltz1=datetimetz'2015-9-17 12:02:06 AM +9:00';
select c_tltz1,extract (HOUR FROM c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,extract (HOUR FROM c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 8:00:00 PM +9:00';
select c_tltz1,HOUR(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,HOUR(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 8:00:00 PM +9:00';

update tztest set c_tltz1=null where  c_tltz1=datetimetz'2015-9-17 12:00:03 PM +9:00';
select c_tltz1,HOUR( c_tltz1 ) from tztest where  c_tltz1 is null;

select c_tltz1,MINUTE(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,MINUTE(c_tltz1 ) from tztest where c_tltz1 is null;

select c_tltz1,second(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,second(c_tltz1 ) from tztest where c_tltz1 is null;

select c_tltz1,time_to_sec(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,time_to_sec(c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 8:00:00 PM +9:00';
select c_tltz1,time_to_sec(c_tltz1 ) from tztest where c_tltz1 is null;

select c_tltz1,TIMEDIFF(addtime(c_tltz1,time'1:00:00'),c_tltz1) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,TIMEDIFF(c_tltz1,c_tltz1 ) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,TIMEDIFF(c_tltz1,c_tltz1) from tztest where c_tltz1 is null;

select c_tltz1,timestamp('2009-12-31',c_tltz1) from tztest where id=4 and SECOND(c_tltz1)=13;
select c_tsltz1,c_tltz1,timestamp(c_tsltz1, c_tltz1) from tztest where c_tltz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_tltz1,timestamp(c_tsltz1, c_tltz1) from tztest where c_tltz1 is null;

--+++++++++Test Case - timetz++++++++++++++++++++++++++++++++++++++++
select c_ttz1,addtime(c_ttz1, time'12:59:1') from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00'; 
--CUBRIDSUS-17532
--select c_ttz1,addtime(c_ttz1, '12:59:1') from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00'; 
select c_ttz1,addtime(c_ttz1, time'23:59:1') from tztest where c_ttz1=datetimetz'2015-9-17 12:00:02 AM +9:00';

update tztest set c_ttz1=addtime(c_ttz1,time'12:00:01') where c_ttz1=datetimetz'2015-9-17 12:00:02 AM +9:00';
select c_ttz1,c_ttz2,addtime(c_ttz1, c_ttz2 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:00:03 PM +9:00' order by 1,2,3;

select c_ttz1,c_dtltz1,addtime(c_ttz1, c_dtltz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,c_dtltz1,addtime(c_ttz1, cast(c_dtltz1 as time) ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,c_dtltz1,addtime(c_ttz1, cast(c_dtltz1 as timestamp) ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,c_dtltz1,addtime(c_ttz1, cast(c_dtltz1 as timestamptz) ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
--CUBRIDSUS-17532
--select c_ttz1,c_dtltz1,addtime(c_ttz1, cast(c_dtltz1 as string) ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
 
update tztest set c_ttz1='8:00:00 PM +9:00' where c_ttz1=datetimetz'2015-9-17 12:02:06 AM +9:00';
select c_ttz1,extract (HOUR FROM c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,extract (HOUR FROM c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 8:00:00 PM +9:00';
select c_ttz1,HOUR(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,HOUR(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 8:00:00 PM +9:00';

update tztest set c_ttz1=null where  c_ttz1=datetimetz'2015-9-17 12:00:03 PM +9:00';
select c_ttz1,HOUR( c_ttz1 ) from tztest where  c_ttz1 is null;

select c_ttz1,MINUTE(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,MINUTE(c_ttz1 ) from tztest where c_ttz1 is null;

select c_ttz1,second(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,second(c_ttz1 ) from tztest where c_ttz1 is null;

select c_ttz1,time_to_sec(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,time_to_sec(c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 8:00:00 PM +9:00';
select c_ttz1,time_to_sec(c_ttz1 ) from tztest where c_tltz1 is null;

select c_ttz1,TIMEDIFF(addtime(c_ttz1,time'1:00:00'),c_ttz1) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,TIMEDIFF(c_ttz1,c_ttz1 ) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,TIMEDIFF(c_ttz1,c_ttz1) from tztest where c_ttz1 is null;

select c_ttz1,timestamp('2009-12-31',c_ttz1) from tztest where id=4 and SECOND(c_ttz1)=13;
select c_tsltz1,c_ttz1,timestamp(c_tsltz1, c_ttz1) from tztest where c_ttz1=datetimetz'2015-9-17 12:02:02 AM +9:00';
select c_ttz1,timestamp(c_tsltz1, c_ttz1) from tztest where c_ttz1 is null;

drop table tztest;
