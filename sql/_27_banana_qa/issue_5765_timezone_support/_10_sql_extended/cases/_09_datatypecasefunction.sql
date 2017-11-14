set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_tsltz2 timestampltz,
    c_dtltz1 datetimeltz, c_dtltz2 datetimeltz,
     primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_tsltz2);

insert into tztest values(1,'abcd',timestampltz'2015-1-1 12:10:00 AM +9:00',timestampltz'2000-10-1 12:00:00 AM +9:00',
     datetimeltz'2015-2-1 12:10:00 AM +9:00', datetimeltz'2000-10-1 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'2015-1-2 2:30:30 PM +9:00',timestampltz'2000-10-2 12:00:00 AM +9:00',
     datetimeltz'2015-2-2 2:30:30 PM +9:00', datetimeltz'2000-10-2 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'2015-1-3 5:02:02 AM +9:00',timestampltz'2000-10-3 12:00:00 AM +9:00',
     null, datetimeltz'2000-10-3 12:00:00 AM +9:00');

insert into tztest select 2,null,addtime(c_tsltz1,time'0:01:00'),addtime(c_tsltz2,time'0:00:01')
,addtime(c_dtltz1,time'0:01:00'),addtime(c_dtltz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_tsltz1,time'0:02:01'),addtime(c_tsltz2,time'0:01:00')
,addtime(c_dtltz1,time'0:02:01'),addtime(c_dtltz2,time'0:01:00') from tztest;

--+++++++++++Test case timestampltz++++++++++++++++++++++++++++++
select CAST( c_tsltz1 AS INT ) from tztest where id=1 order by 1,2;
select CAST( c_tsltz1 AS SMALLINT ) from tztest where id=1 order by 1,2;
select CAST( c_tsltz1 AS BIGiNT ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS CHAR(35) ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS VARCHAR ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS TIME ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS TIMESTAMP ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS TIMESTAMPTZ ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS TIMESTAMPLTZ ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS DATE ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS DATETIME ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS DATETIMETZ ) from tztest where id=1 order by 1,2;
select c_tsltz1,CAST( c_tsltz1 AS DATETIMELTZ ) from tztest where id=1 order by 1,2;

select c_tsltz1,date_format(c_tsltz1,'%W %M %Y') from tztest where id=2 order by 1,2;
select c_tsltz1,date_format(c_tsltz1,'%D %y %a %d %m %b %j') from tztest where id=2 order by 1,2;

select c_tsltz1,time_format(c_tsltz1,'%H %h %i %s %f') from tztest where id=2 order by 1,2;
select c_tsltz1,time_format(c_tsltz1,'%p')from tztest where id=2 order by 1,2;

select c_tsltz1,to_char(c_tsltz1) from tztest where id=2 order by 1,2;
select c_tsltz1,to_char(c_tsltz1,'DD, DY , MON, YYYY') from tztest where id=2 order by 1,2;
select c_tsltz1,to_char(c_tsltz1,'YYYY-MM-DD-DAY') from tztest where id=2 order by 1,2;
select c_tsltz1,to_char(c_tsltz1,'Day Month yyyy') from tztest where id=2 order by 1,2;

--+++++++++++Test case datetimeltz++++++++++++++++++++++++++++++
select CAST( c_dtltz1 AS INT ) from tztest where id=1;
select CAST( c_dtltz1 AS SMALLINT ) from tztest where id=1;
select CAST( c_dtltz1 AS BIGiNT ) from tztest where id=1;
select c_dtltz1,CAST( c_dtltz1 AS CHAR(40) ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS VARCHAR ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS TIME ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS TIMESTAMP ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS TIMESTAMPTZ ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS TIMESTAMPLTZ ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS DATE ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS DATETIME ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS DATETIMETZ ) from tztest where id=1 order by 1,2;
select c_dtltz1,CAST( c_dtltz1 AS DATETIMELTZ ) from tztest where id=1 order by 1,2;

select c_dtltz1,date_format(c_dtltz1,'%W %M %Y') from tztest where id=2 order by 1,2;
select c_dtltz1,date_format(c_dtltz1,'%D %y %a %d %m %b %j') from tztest where id=2 order by 1,2;

select c_dtltz1,time_format(c_dtltz1,'%H %h %i %s %f') from tztest where id=2 order by 1,2;
select c_dtltz1,time_format(c_dtltz1,'%p')from tztest where id=2 order by 1,2;

select c_dtltz1,to_char(c_dtltz1) from tztest where id=2 order by 1,2;
select c_dtltz1,to_char(c_dtltz1,'DD, DY , MON, YYYY') from tztest where id=2 order by 1,2;
select c_dtltz1,to_char(c_dtltz1,'YYYY-MM-DD-DAY') from tztest where id=2 order by 1,2;
select c_dtltz1,to_char(c_dtltz1,'Day Month yyyy') from tztest where id=2 order by 1,2;


drop table tztest;
