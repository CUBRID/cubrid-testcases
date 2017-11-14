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
     datetimeltz'2015-2-2 5:30:30 PM +9:00', datetimeltz'2000-10-3 12:00:00 AM +9:00');

insert into tztest select 2,null,addtime(c_tsltz1,time'0:01:00'),addtime(c_tsltz2,time'0:00:01')
 ,addtime(c_dtltz1,time'0:01:00'),addtime(c_dtltz2,time'0:00:01') from tztest;
insert into tztest select 3,null,addtime(c_tsltz1,time'0:02:01'),addtime(c_tsltz2,time'0:01:00')
 ,addtime(c_dtltz1,time'0:02:01'),addtime(c_dtltz2,time'0:01:00') from tztest;

--++++++++++++++Test case timestampltz++++++++++++++++++++++++++++++++++++++++++
update tztest set c_tsltz2=null where c_tsltz2 in (timestampltz'2000-10-3 12:00:00 AM +9:00');
select c_tsltz1,c_tsltz2,IFNULL(c_tsltz2,c_tsltz1) from tztest where id =1 order by 1,2; 
select c_tsltz1,c_tsltz2,NVL(c_tsltz2,c_tsltz1) from tztest where  id =1 order by 1,2;
select c_tsltz1,c_tsltz2,NVL2(c_tsltz2,c_tsltz2,c_tsltz1) from tztest where id =1 order by 1,2;
select c_tsltz1,c_tsltz2 from tztest where isnull(c_tsltz2) order by 1,2;

--++++++++++++++Test case datetimeltz++++++++++++++++++++++++++++++++++++++++++
update tztest set c_dtltz2=null where c_dtltz2 in (datetimeltz'2000-10-3 12:00:00 AM +9:00');
select c_dtltz1,c_dtltz2,IFNULL(c_dtltz2,c_dtltz1) from tztest where id =1 order by 1,2;
select c_dtltz1,c_dtltz2,NVL(c_dtltz2,c_dtltz1) from tztest where  id =1 order by 1,2;
select c_dtltz1,c_dtltz2,NVL2(c_dtltz2,c_dtltz2,c_dtltz1) from tztest where id =1 order by 1,2;
select c_dtltz1,c_dtltz2 from tztest where isnull(c_dtltz2) order by 1,2;


drop table tztest;

