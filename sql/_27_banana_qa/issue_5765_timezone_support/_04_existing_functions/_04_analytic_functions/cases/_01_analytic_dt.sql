--test analytic functions with datetime(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone, gid int);

insert into tz_test values(1, datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', 1);
insert into tz_test values(2, null, datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', 3);
insert into tz_test values(3, datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', 1);
insert into tz_test values(4, datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', 2);
insert into tz_test values(5, datetimetz'2015-08-13 14:00:00.999 Antarctica/Davis', datetimetz'2015-08-13 14:00:00.999 Antarctica/Davis', null, 3);
insert into tz_test values(6, datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', datetimetz'2023-03-23 23:59:59.999 Asia/Taipei', datetimetz'2023-03-23 23:59:59.999 Asia/Taipei', 2);
insert into tz_test values(7, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', null, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', 1);
insert into tz_test values(8, datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', 3);

set time zone 'America/Los_Angeles';
--test: agrregate functions
select count(ts) over(partition by gid order by id) ts_cnt, count(dtltz) over(partition by gid order by id) dtltz_cnt, count(dttz) over(partition by gid order by id desc) dttz_cnt from tz_test;

select id, ts, cume_dist() over(order by ts) as cume from tz_test order by id; 
select id, dtltz, cume_dist() over(partition by dttz order by dtltz) as cume from tz_test order by id; 
select gid, cume_dist() over(partition by dttz order by dtltz) as cume from tz_test group by gid order by 1, 2; 
select gid, dttz, cume_dist() over(partition by gid order by dttz desc) as cume from tz_test order by gid, dttz desc; 
select gid, ts, dttz, cume_dist() over(partition by gid order by dtltz, dttz desc) as cume from tz_test order by gid, dttz desc; 

select ts, dense_rank() over(order by ts) as drank from tz_test order by 1;
select dtltz, dense_rank() over(order by dtltz desc) drank from tz_test order by 1 desc;
select gid, dttz, dtltz, dense_rank() over(partition by gid order by dttz, dtltz desc) drank from tz_test order by 1, 2;

select id, ts, first_value(ts) over(order by ts) as fv from tz_test order by 1;
select id, dtltz, first_value(dtltz) over(order by dtltz desc) as fv from tz_test order by dtltz desc;
select gid, dttz, first_value(dttz) over(partition by gid order by dttz) as fv from tz_test order by 1, 2;

select id, ts, lag(ts, 1) over(order by ts) as lag from tz_test order by 1, 2;
select id, dtltz, lag(dtltz, 2) over(order by dtltz) as lag from tz_test order by 1, 2;
select gid, dttz, lag(dttz, 1) over(partition by gid order by dttz desc) as lag from tz_test order by 1, 2 desc;

select id, ts, last_value(ts) over(order by dtltz) as lv from tz_test order by 1;
select id, dtltz, last_value(dtltz) over(order by dttz desc) as lv from tz_test order by dtltz desc;
select gid, dttz, last_value(dttz) over(partition by gid order by dtltz) as lv from tz_test order by 1, 2;

select id, ts, lead(ts, 1) over(order by dtltz) as lead from tz_test order by 1, 2;
select id, dtltz, lead(dtltz, 2) over(order by dttz) as lead from tz_test order by 1, 2;
select gid, dttz, lead(dttz, 1) over(partition by gid order by ts desc) as lead from tz_test order by 1, 2 desc;

select gid, max(ts) over() max_ts, max(dtltz) over(partition by gid) max_dtltz, max(dttz) over(partition by gid order by id desc) max_dttz from tz_test order by gid, 2, 3;

select id, ts, median(ts) over() median from tz_test order by 1;
--BUG: CUBRIDSUS-16435
select gid, dttz, median(dttz) over(partition by gid) median from tz_test;
select gid, dtltz, median(dtltz) over(partition by gid, dtltz) median from tz_test;
 
select gid, dttz, min(ts) over() min_ts, min(dtltz) over(partition by gid) min_dtltz, min(dttz) over(partition by gid order by id desc) min_dttz from tz_test order by gid, 2, 3;

select id, ts, nth_value(ts, 2) ignore nulls over(order by dtltz) nv from tz_test; 
select id, dtltz, nth_value(dtltz, 2) over(order by id desc) nv from tz_test; 
select gid, dttz, nth_value(dttz, 2) over(partition by gid order by id) nv from tz_test; 

select id, ts, ntile(3) over(order by ts) n_group from tz_test;
select id, dtltz, ntile(4) over(order by dtltz desc) n_group from tz_test;
select id, dttz, ntile(2) over(partition by gid order by dttz) n_group from tz_test;

select id, ts, percent_rank() over(order by ts) as prank from tz_test; 
select id, dttz, percent_rank() over(order by dttz desc) as prank from tz_test; 
select gid, dtltz, percent_rank() over(partition by gid order by dtltz desc) as prank from tz_test; 

select id, ts, rank() over(order by ts) rank from tz_test;
select id, dtltz, rank() over(order by dtltz desc) rank from tz_test;
select gid, dttz, rank() over(partition by gid order by dttz) rank from tz_test;

drop table tz_test;


set timezone 'Asia/Seoul';
