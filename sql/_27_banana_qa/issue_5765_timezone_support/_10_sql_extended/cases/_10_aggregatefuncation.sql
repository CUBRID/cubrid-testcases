set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),
    c_tsltz1 timestampltz, c_dtltz1 datetimeltz,
    primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_dtltz1);

insert into tztest values(1,'abcd',timestampltz'1990-1-1 12:00:00 AM +9:00',datetimeltz'2000-10-1 12:00:00 AM +9:00'
     );
insert into tztest values(1,'abcd',timestampltz'1990-1-2 12:00:00 AM +9:00',datetimeltz'2000-10-2 12:00:00 AM +9:00'
     );
insert into tztest values(1,'abcd',timestampltz'1990-1-3 12:00:00 AM +9:00',datetimeltz'2000-10-3 12:00:00 AM +9:00'
     );
insert into tztest values(1,'abcd',timestampltz'1990-1-4 12:00:00 AM +9:00',datetimeltz'2000-10-4 12:00:00 AM +9:00'
     );

--+++++++++++++++++Test case timestampltz++++++++++++++
select max(c_tsltz1) from tztest where id =1;
select min(c_tsltz1) from tztest where id =1;
select count(c_tsltz1) from tztest where id=1;

--+++++++++++++++++Test case datetimeltz++++++++++++++
select max(c_dtltz1) from tztest where id =1;
select min(c_dtltz1) from tztest where id =1;
select count(c_dtltz1) from tztest where id=1;

drop table tztest;

