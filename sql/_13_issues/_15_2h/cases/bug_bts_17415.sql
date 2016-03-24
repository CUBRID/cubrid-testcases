set timezone 'Asia/Seoul';
--time datatype
drop table if exists tb1;
create table tb1(   c_int int,        col1 time);
insert into tb1 values(1,'12:00:01 AM');
insert into tb1 values(2,'05:00:01 AM');
insert into tb1 values(3,'05:27:51 PM');
select * from tb1 order by col1;
drop table tb1;


--timestamptz
drop table if exists tb4;
create table tb4( c_int int,col1 timestamp with time zone);
insert into tb4 values(1,'2003-03-30 12:00:01 AM +0:00');
insert into tb4 values(2,'2003-03-30 05:00:01 AM +9:00');
insert into tb4 values(3,'2003-03-30 05:27:51 PM +7:00');
select * from tb4 order by col1;
drop table tb4;
