--conversion from date/time to enum
create table t1 (dt1 timestamp, dt2 datetime, dt3 date, dt4 time);
insert into t1 values ('11:00:00 AM 02/21/2012', '01:13:13.000 PM 12/21/2012', '12/21/2012', '02:29:00 PM');
insert into t1 values ('11:11:11 AM 12/22/2010', '01:13:13.000 PM 12/11/1981', '08/08/2008', '01:02:03 PM');

create table t2 (e1 enum('11:00:00 AM 02/21/2012', '11:11:11 AM 12/22/2010'), e2 enum('01:13:13.000 PM 12/21/2012', '01:13:13.000 PM 12/11/1981'), e3 enum('12/21/2012', '08/08/2008'), e4 enum('02:29:00 PM', '01:02:03 PM'));
insert into t2 select * from t1;

select cast(dt1 as varchar), cast(dt2 as varchar), cast(dt3 as varchar), cast(dt4 as varchar) from t1 order by 1, 2, 3, 4;
select * from t2 order by 1, 2, 3, 4;
select cast(e1 as int), cast(e2 as int), cast(e3 as int), cast(e4 as int) from t2 order by 1, 2, 3, 4;

drop table t1;
drop table t2;