--test TIME(L)Tz columns with same time values but different time zone values, check the order

set timezone '+0:00';

drop table if exists tz_test;
create table tz_test(id int primary key auto_increment, col1 time);

insert into tz_test(col1) values(time'13:00:00' );
insert into tz_test(col1) values(time'13:00:00');
insert into tz_test(col1) values(time'12:00:00 PM');
insert into tz_test(col1) values(time'15:00:00');
insert into tz_test(col1) values(time'15:00:00');
insert into tz_test(col1) values(time'17:00:00');
insert into tz_test(col1) values(time'10:00:00');
insert into tz_test(col1) values(time'11:00:00');
insert into tz_test(col1) values(time'10:00:00');


--test: check the ordering of time column
select * from tz_test order by col1, id;
select col1 from tz_test order by 1, id;
select col1 from tz_test order by 1 desc, id;

--test: check the ordering of time columns
select col1 from tz_test order by col1 desc, id;


drop table tz_test;

set timezone 'default';















