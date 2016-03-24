--test TIMESTAMP(L)TZ columns, with view

autocommit off;
drop table if exists tz_test;

create table tz_test(id int primary key auto_increment, col1 timestamp with time zone not null default timestamptz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with local time zone);

set timezone 'Asia/Seoul';

insert into tz_test(col1, col2) values(timestamptz'2013-12-10 15:30:00', timestampltz'2013-12-10 15:30:00');
insert into tz_test(col1, col2) values(timestamptz'2013-12-10 3:30:30 PM +9:00', timestampltz'2013-12-10 15:30:00 +9:00');
insert into tz_test(col1, col2) values(timestamptz'2013-12-10 3:00:00 AM -03:30', timestampltz'2013-12-10 3:00:00 -3:30');
insert into tz_test(col1, col2) values(timestamptz'2013-12-10 15:30:00 Asia/Tokyo', timestampltz'2013-12-10 3:30:00 PM Asia/Tokyo');
insert into tz_test(col1, col2) values(timestamptz'2013-12-10 8:30:00 Europe/Bucharest', timestampltz'2013-12-10 8:30:00 Europe/Riga');

commit;

--test: create normal view
create view v1 as select * from tz_test;
desc v1;
show create view v1;

set timezone 'Europe/Bucharest';
insert into v1(col1, col2) values(timestamptz'1992-07-10 2:00:00', timestampltz'1992-07-10 2:00:00');
insert into v1(col1, col2) values(timestamptz'1992-07-10 3:00:00 Europe/Bucharest', timestampltz'1992-07-10 3:00:00 Europe/Bucharest');
set timezone '+2:00';
insert into v1(col1, col2) values(timestamptz'1992-07-10 2:00:00', timestampltz'1992-07-10 2:00:00 +2:00');


--test: select from view
set timezone 'Asia/Seoul';
select all * from v1 order by id;

set timezone 'Europe/Bucharest';
select distinct tv2.col1 from (select id,col1 from v1 order by 1) tv2 order by 1;
select unique tv2.col1, tv2.col2 from (select id,col1,col2 from tz_test order by id) tv2 order by 1;

--test: alter view
alter view v1 as select * from tz_test where col1<timestamptz'2013-12-10 15:30:00 +8:59' and col2>timestamptz'1992-07-10 2:00:00';
update v1 set col1=col1+3600, col2='2010-12-31 9:00:00 Asia/Tokyo';
select * from v1 order by 1, 2, 3;
update tz_test set col2=timestamptz'2014-10-31';
select * from v1 order by 1, 2, 3;

rollback;

--test: create view with check option
create view v2 as select * from tz_test where col1<timestamptz'2013-12-10 15:30:01 +9:00' and col2>timestampltz'2011-05-12 8:12:55 PM' with check option;
--test: [er] violate the view condition
update v2 set col1=timestamptz'2015-01-01 12:12:12 -10:00';
select * from v2 order by 1, 2, 3;
--test: [er] violate the view condition
update v2 set col1=col1+1;
--test: update the view with check option
update v2 set col1=col1-1, col2=col2+1;
select * from v2 order by 1, 2, 3;


drop view v2;
drop table tz_test;

set timezone 'Asia/Seoul';

commit;
autocommit on;

 
