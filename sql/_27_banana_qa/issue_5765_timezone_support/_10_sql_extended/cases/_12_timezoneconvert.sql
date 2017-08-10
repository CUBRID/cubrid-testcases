set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_tstz1 timestamptz, c_dtltz1 datetimeltz,c_dttz1 datetimetz,
    primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_dtltz1);

insert into tztest values(1,'abcd',timestampltz'1990-1-1 12:00:00 AM +9:00',timestamptz'1990-1-1 12:00:00 AM +9:00',
datetimeltz'2000-10-1 12:00:00 AM +9:00',datetimetz'2000-10-1 12:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-2 2:00:00 AM +9:00',timestamptz'1990-1-2 2:00:00 AM +9:00',
datetimeltz'2000-10-2 2:00:00 AM +9:00',datetimetz'2000-10-2 2:00:00 AM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-3 2:00:00 PM +9:00',timestamptz'1990-1-3 2:00:00 PM +9:00',
datetimeltz'2000-10-3 2:00:00 PM +9:00',datetimetz'2000-10-3 2:00:00 PM +9:00');
insert into tztest values(1,'abcd',timestampltz'1990-1-4 9:00:10 AM +9:00',timestamptz'1990-1-4 9:00:10 AM +9:00',
datetimeltz'2000-10-4 11:00:00 PM +9:00',datetimeltz'2000-10-4 11:00:00 PM +9:00');

--+++++++++++++++++Test case timestampltz++++++++++++++

set timezone '+0:00';
select c_tsltz1,c_tstz1 from tztest order by c_tsltz1;
select c_dtltz1,c_dttz1 from tztest order by c_dtltz1;

set timezone '-3:00';
select c_tsltz1,c_tstz1 from tztest order by c_tsltz1;
select c_dtltz1,c_dttz1 from tztest order by c_dtltz1;

set timezone '+12:00';
select c_tsltz1,c_tstz1 from tztest order by c_tsltz1;
select c_dtltz1,c_dttz1 from tztest order by c_dtltz1;

set timezone '+9:00';
select c_tsltz1,c_tstz1 from tztest order by c_tsltz1;
select c_dtltz1,c_dttz1 from tztest order by c_dtltz1;

drop table tztest;
