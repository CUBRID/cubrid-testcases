set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(9000),
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

--Test Case - timestampltz
select c_tsltz1,CHAR_LENGTH(c_tsltz1) from tztest where id =1 and DAY(c_tsltz1) <5 order by 1;
select CONCAT(c_tsltz1,' ',c_tsltz2) from tztest where id =3 and date(c_tsltz2) ='10/06/2000' order by 1;
select CONCAT(c_tsltz1,' ',c_tsltz2) from tztest where id =3 and cast(date(c_tsltz2) as date)='10/6/2000' order by 1;

select STRCMP(c_tsltz1 , c_tsltz2) from tztest where id =3 and cast(date(c_tsltz2) as date)='10/6/2000' order by 1;
select STRCMP(c_tsltz1 , c_tsltz1) from tztest where id =3 and cast(date(c_tsltz2) as date)='10/6/2000' order by 1;
select concat(UCASE(c_tsltz1),' ', LCASE(c_tsltz2)) from tztest where id =3 and cast(date(c_tsltz2) as date)='10/6/2000' order by 1;

--CUBRIDSUS-17510 resolved
select c_tsltz2,ELT(id,c_tsltz1,c_tsltz2,c_dtltz1,c_dtltz2) from tztest where id=2 and date(c_tsltz2) ='10/01/2000' order by 1;
select c_dtltz1,ELT(id,c_tsltz1,c_tsltz2,c_dtltz1,c_dtltz2) from tztest where id=3 and date(c_tsltz2) ='10/01/2000' order by 1;

select FIELD('12:01:31 AM 10/05/2000 Asia/Seoul KST',c_tsltz1,c_tsltz2,c_dtltz1,c_dtltz2) from tztest where c_tsltz2='12:01:31 AM 10/05/2000 Asia/Seoul' order by 1;
select FIELD('12:01:31 AM 10/05/2000 Asia/Seoul KST',c_tsltz1,c_tsltz2,c_dtltz1,c_dtltz2) from tztest where c_tsltz2='12:01:30 AM 10/05/2000 Asia/Seoul' order by 1;

update tztest set c_varchar=repeat(c_tsltz1||c_dtltz1,100) where c_tsltz2 in (select max(c_tsltz2) from tztest);
select length(c_varchar) from tztest where c_tsltz2 in (select max(c_tsltz2) from tztest) order by 1;

select REPLACE(REPLACE('starttime:XX,endtime:YY','XX',c_tsltz1),'YY',c_tsltz2) from tztest where id=4 and day(c_tsltz1)=5 order by 1;

--Test Case - datetimeltz
select c_dtltz1,CHAR_LENGTH(c_dtltz1) from tztest where id =1 and DAY(c_dtltz1) <5 order by 1;
select CONCAT(c_dtltz1,' ',c_dtltz2) from tztest where id =3 and date(c_dtltz2) ='10/06/2000' order by 1;
select CONCAT(c_dtltz1,' ',c_dtltz2) from tztest where id =3 and cast(date(c_dtltz2) as date)='10/6/2000' order by 1;

select STRCMP(c_dtltz1 , c_dtltz2) from tztest where id =3 and cast(date(c_dtltz2) as date)='10/6/2000' order by 1;
select STRCMP(c_dtltz1 , c_dtltz1) from tztest where id =3 and cast(date(c_dtltz2) as date)='10/6/2000' order by 1;
select concat(UCASE(c_dtltz1),' ', LCASE(c_dtltz2)) from tztest where id =3 and cast(date(c_dtltz2) as date)='10/6/2000' order by 1;

--CUBRIDSUS-17510
--select ELT(id,c_dtltz1,c_dtltz2,c_dtltz1,c_dtltz2) from tztest where id=2 and date(c_dtltz2) ='10/01/2000';
--select ELT(id,c_dtltz1,c_dtltz2,c_dtltz1,c_dtltz2) from tztest where id=3 and date(c_dtltz2) ='10/01/2000';

select FIELD('12:01:31.000 AM 10/05/2000 Asia/Seoul KST',c_dtltz1,c_dtltz2,c_dtltz1,c_dtltz2) from tztest where c_dtltz2='12:01:31 AM 10/05/2000 Asia/Seoul' order by 1;

update tztest set c_varchar=repeat(c_dtltz1||c_dtltz1,100)  where c_dtltz2 in (select max(c_dtltz2) from tztest);
select length(c_varchar) from tztest where c_dtltz2 in (select max(c_dtltz2) from tztest) order by 1;

select REPLACE(REPLACE('starttime:XX,endtime:YY','XX',c_tsltz1),'YY',c_tsltz2) from tztest where id=4 and minute(c_tsltz1)=3 and day(c_tsltz1)=5 order by 1;

--Test case -timeltz
--CUBRIDSUS-17510
--select ELT(id,c_tltz1,c_tltz2) from tztest where id=1 and c_tltz1='00:00:05 AM +9:00';
--select ELT(id,c_tltz1,c_tltz2) from tztest where id=2 and c_tltz1='00:00:05 AM +9:00';

drop table tztest;

