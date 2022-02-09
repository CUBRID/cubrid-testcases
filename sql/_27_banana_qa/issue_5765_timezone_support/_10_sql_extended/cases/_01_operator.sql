set timezone 'Asia/Seoul';
--precondition 
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_tsltz2 timestampltz,
    c_dtltz1 datetimeltz, c_dtltz2 datetimeltz,
    primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_tsltz2);

insert into tztest values(1,'abcd',timestampltz'1990-1-1 12:00:00 AM +9:00',timestampltz'2000-10-1 12:00:00 AM +9:00',
     datetimeltz'1990-1-1 12:00:00 AM +9:00', datetimeltz'2000-10-1 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-2 12:00:00 AM +9:00',timestampltz'2000-10-2 12:00:00 AM +9:00',
     datetimeltz'1990-1-2 12:00:00 AM +9:00', datetimeltz'2000-10-2 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-3 12:00:00 AM +9:00',timestampltz'2000-10-3 12:00:00 AM +9:00',
     datetimeltz'1990-1-3 12:00:00 AM +9:00', datetimeltz'2000-10-3 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-4 12:00:00 AM +9:00',timestampltz'2000-10-4 12:00:00 AM +9:00',
     datetimeltz'1990-1-4 12:00:00 AM +9:00', datetimeltz'2000-10-4 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-5 12:00:00 AM +9:00',timestampltz'2000-10-5 12:00:00 AM +9:00',
     datetimeltz'1990-1-5 12:00:00 AM +9:00', datetimeltz'2000-10-5 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-6 12:00:00 AM +9:00',timestampltz'2000-10-6 12:00:00 AM +9:00',
     datetimeltz'1990-1-6 12:00:00 AM +9:00', datetimeltz'2000-10-6 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-7 12:00:00 AM +9:00',timestampltz'2000-10-7 12:00:00 AM +9:00',
     datetimeltz'1990-1-7 12:00:00 AM +9:00', datetimeltz'2000-10-7 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-8 12:00:00 AM +9:00',timestampltz'2000-10-8 12:00:00 AM +9:00',
     datetimeltz'1990-1-8 12:00:00 AM +9:00', datetimeltz'2000-10-8 12:00:00 AM +9:00');

insert into tztest select 2,null,addtime(c_tsltz1,time'0:01:00'),addtime(c_tsltz2,time'0:00:01'),
  addtime(c_dtltz1,time'0:01:00'),addtime(c_dtltz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_tsltz1,time'0:02:01'),addtime(c_tsltz2,time'0:01:00'),
  addtime(c_dtltz1,time'0:02:01'),addtime(c_dtltz2,time'0:01:00') from tztest;
insert into tztest select 4,null,addtime(c_tsltz1,time'0:03:10'),addtime(c_tsltz2,time'0:00:30'),
  addtime(c_dtltz1,time'0:03:10'),addtime(c_dtltz2,time'0:00:30') from tztest;
insert into tztest select 5,null,addtime(c_tsltz1,time'1:04:01'),addtime(c_tsltz2,time'0:05:04'),
   addtime(c_tsltz1,time'1:04:01'),addtime(c_tsltz2,time'0:05:04')  from tztest;
insert into tztest select 6,null,addtime(c_tsltz1,time'2:04:10'),addtime(c_tsltz2,time'0:06:10'),
   addtime(c_tsltz1,time'2:04:10'),addtime(c_tsltz2,time'0:06:10') from tztest;

--+++++++++++++++++++++++Test Case - timestampltz++++++++++++++++++++++++++++++++++++++++
--Logical Operators
select (c_tsltz1<>0 and c_tsltz2<>0) from tztest where id =1 and c_tsltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (c_tsltz1<>0 or c_tsltz2<>0) from tztest where id =1 and c_tsltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (c_tsltz1<>0 xor c_tsltz2<>0) from tztest where id =1 and c_tsltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (not c_tsltz2<>0) from tztest where id =1 and c_tsltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');

update tztest set c_tsltz2=null where c_tsltz1='12:00:00 AM 01/01/1990';
select (c_tsltz1<>0 and c_tsltz2<>0) from tztest where id =1 and c_tsltz1 in ('12:00:00 AM 01/01/1990');
select (c_tsltz1<>0 or c_tsltz2<>0) from tztest where id =1 and c_tsltz1 in ('12:00:00 AM 01/01/1990');
select (c_tsltz1<>0 xor c_tsltz2<>0) from tztest where id =1 and c_tsltz1 in ('12:00:00 AM 01/01/1990');
select (not c_tsltz2<>0) from tztest where id =1 and c_tsltz1 in ('12:00:00 AM 01/01/1990');

--Comparison Operators
select c_tsltz1, c_tsltz2 from tztest where c_tsltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_tsltz1 <'12:00:00 PM 01/05/1990 +9:00'
     and c_tsltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_tsltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_tsltz1;
select c_tsltz1 = CAST(c_tsltz1 AS datetimetz) from tztest where c_tsltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');

--Arithmetic Operators
select (c_tsltz1 + c_tsltz2) from tztest  where c_tsltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_tsltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_tsltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_tsltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_tsltz1;
--A subtraction is allowed. BIGINT
select (c_tsltz1 - c_tsltz2) from tztest  where c_tsltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_tsltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_tsltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_tsltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_tsltz1;
select (c_tsltz1 - c_dtltz1) from tztest  where c_tsltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_tsltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_tsltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_tsltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_tsltz1;
--timestamp type + 3600(seconds) returns timestamp type
select c_tsltz1, (c_tsltz1 + 3600) from tztest  where c_tsltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_tsltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_tsltz2 > '12:11:44 AM 10/05/2000 +9:00' and c_tsltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_tsltz1;

--Concatenation Operator
select extract(year from c_tsltz1)||extract(month from c_tsltz1)||' '||extract(year from c_tsltz2)||extract(month from c_tsltz2) as extract_result from tztest where id =1 and DAY(c_tsltz1) <5;

--++++++++++++++++++++++++++++Test Case - datetimeltz++++++++++++++++++++++++++++
--Logical Operators
select (c_dtltz1<>0 and c_dtltz2<>0) from tztest where id =1 and c_dtltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (c_dtltz1<>0 or c_dtltz2<>0) from tztest where id =1 and c_dtltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (c_dtltz1<>0 xor c_dtltz2<>0) from tztest where id =1 and c_dtltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');
select (not c_dtltz2<>0) from tztest where id =1 and c_dtltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');

update tztest set c_dtltz2=null where c_dtltz1='12:00:00 AM 01/01/1990';
select (c_dtltz1<>0 and c_dtltz2<>0) from tztest where id =1 and c_dtltz1 in ('12:00:00 AM 01/01/1990');
select (c_dtltz1<>0 or c_dtltz2<>0) from tztest where id =1 and c_dtltz1 in ('12:00:00 AM 01/01/1990');
select (c_dtltz1<>0 xor c_dtltz2<>0) from tztest where id =1 and c_dtltz1 in ('12:00:00 AM 01/01/1990');
select (not c_dtltz2<>0) from tztest where id =1 and c_dtltz1 in ('12:00:00 AM 01/01/1990');

--Comparison Operators
select c_dtltz1, c_dtltz2 from tztest where c_dtltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_dtltz1 <'12:00:00 PM 01/05/1990 +9:00'
     and c_dtltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_dtltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_dtltz1;
select c_dtltz1 = CAST(c_dtltz1 AS datetimetz) from tztest where c_dtltz2 in ('12:00:00 AM 10/02/2000 Asia/Seoul');

--Arithmetic Operators
select (c_dtltz1 + c_dtltz2) from tztest  where c_dtltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_dtltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_dtltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_dtltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_dtltz1;
--A subtraction is allowed. BIGINT
select (c_dtltz1 - c_dtltz2) from tztest  where c_dtltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_dtltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_dtltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_dtltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_dtltz1;
select (c_dtltz1 - c_dtltz1) from tztest  where c_dtltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_dtltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_dtltz2 > '12:11:44 AM 10/05/2000 Asia/Seoul' and c_dtltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_dtltz1;
--timestamp type + 3600(seconds) returns timestamp type
select c_dtltz1, (c_dtltz1 + 3600) from tztest  where c_dtltz1 >='12:00:00 AM 01/05/1990 +9:00' and c_dtltz1 <'12:00:00 PM 01/05/1990 +9:00'
    and c_dtltz2 > '12:11:44 AM 10/05/2000 +9:00' and c_dtltz2 <= '12:12:45 AM 10/05/2000 Asia/Seoul ' order by c_dtltz1;

--Concatenation Operator
select extract(year from c_dtltz1)||extract(month from c_dtltz1)||' '||extract(year from c_dtltz2)||extract(month from c_dtltz2) as extract_result from tztest where id =1 and
DAY(c_dtltz1) <5;

--+++++++++++++++++++++++++++++++++++++Test case - timeltz++++++++++++++++++++++++++++
--Logical Operators
--CUBRIDSUS-17503
--select (c_tltz1 and c_tltz2) from tztest where id =2 and c_tltz2 = ('9:01:00 AM +9:00');
--select (c_tltz1 or c_tltz2) from tztest where id =3 and c_tltz2 in ('9:01:00 AM +9:00');
--select (c_tltz1 xor c_tltz2) from tztest where id =1 and c_tltz2 = ('9:01:00 AM +9:00');
--select (not c_tltz2) from tztest where id =4 and c_tltz2 in ('9:01:00 AM +9:00');

--update tztest set c_tltz2=null where  id =2 and c_tltz1='9:01:00 AM +9:00';
--select (c_tltz1 and c_tltz2) from tztest where id =2 and c_tltz1 in ('9:01:00 AM +9:00');
--select (c_tltz1 or c_tltz2) from tztest where id =2 and c_tltz1 in ('9:01:00 AM +9:00');
--select (c_tltz1 xor c_tltz2) from tztest where id =2 and c_tltz1 in ('9:01:00 AM +9:00');
--select (not c_tltz2) from tztest where id =2 and c_tltz1 in ('9:01:00 AM +9:00');

--Comparison Operators
--CUBRIDSUS-17415
--select c_tltz1, c_tltz2 from tztest where c_tltz1 >='12:00:00 AM +9:00' and c_tltz1 <'12:00:00 PM +9:00'
--     and c_tltz2 > '09:01:00 AM +9:00' and c_tltz2 <= '09:04:00 AM +9:00' order by c_tltz1;

--Arithmetic Operators
--CUBRIDSUS-17505
--select (c_tltz1 - c_tltz2) from tztest  where c_tltz1 in ('12:00:01 AM +9:00') and c_tltz2 = ('09:01:00 AM +9:00');
--update tztest set c_tltz2 = ('09:01:00 PM +9:00') where c_tltz1 in ('12:00:01 AM +9:00') and c_tltz2 = ('09:01:00 AM +9:00');
--select (c_tltz1 - c_tltz2) from tztest  where c_tltz1 in ('12:00:01 AM +9:00') and c_tltz2 = ('09:01:00 PM +9:00');
--select (c_tltz1 - c_tltz1) from tztest  where c_tltz1 in ('12:00:01 AM +9:00') and c_tltz2 = ('09:01:00 PM +9:00');

--Concatenation Operator

drop table tztest;
