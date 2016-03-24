--test analytic functions with timestamp(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', 1);
insert into tz_test values(2, null, timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', 3);
insert into tz_test values(3, timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', 1);
insert into tz_test values(4, timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', 2);
insert into tz_test values(5, timestamptz'2015-08-13 14:00:00 Antarctica/Davis', timestamptz'2015-08-13 14:00:00 Antarctica/Davis', null, 3);
insert into tz_test values(6, timestamptz'2023-03-23 18:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', 2);
insert into tz_test values(7, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', null, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', 1);
insert into tz_test values(8, timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', 3);

set time zone 'America/Los_Angeles';
--test: agrregate functions
select count(ts) over(partition by gid order by id) ts_cnt, count(tsltz) over(partition by gid order by id) tsltz_cnt, count(tstz) over(partition by gid order by id desc) tstz_cnt from tz_test;

select id, ts, cume_dist() over(order by ts) as cume from tz_test order by id; 
select id, tsltz, cume_dist() over(partition by tstz order by tsltz) as cume from tz_test order by id; 
select gid, cume_dist() over(partition by tstz order by tsltz) as cume from tz_test group by gid order by 1, 2; 
select gid, tstz, cume_dist() over(partition by gid order by tstz desc) as cume from tz_test order by gid, tstz desc; 
select gid, ts, tstz, cume_dist() over(partition by gid order by tsltz, tstz desc) as cume from tz_test order by gid, tstz desc; 

select ts, dense_rank() over(order by ts) as drank from tz_test order by 1;
select tsltz, dense_rank() over(order by tsltz desc) drank from tz_test order by 1 desc;
select gid, tstz, tsltz, dense_rank() over(partition by gid order by tstz, tsltz desc) drank from tz_test order by 1, 2;

select id, ts, first_value(ts) over(order by ts) as fv from tz_test order by 1;
select id, tsltz, first_value(tsltz) over(order by tsltz desc) as fv from tz_test order by tsltz desc;
select gid, tstz, first_value(tstz) over(partition by gid order by tstz) as fv from tz_test order by 1, 2;

select id, ts, lag(ts, 1) over(order by ts) as lag from tz_test order by 1, 2;
select id, tsltz, lag(tsltz, 2) over(order by tsltz) as lag from tz_test order by 1, 2;
select gid, tstz, lag(tstz, 1) over(partition by gid order by tstz desc) as lag from tz_test order by 1, 2 desc;

select id, ts, last_value(ts) over(order by tsltz) as lv from tz_test order by 1;
select id, tsltz, last_value(tsltz) over(order by tstz desc) as lv from tz_test order by tsltz desc;
select gid, tstz, last_value(tstz) over(partition by gid order by tsltz) as lv from tz_test order by 1, 2;

select id, ts, lead(ts, 1) over(order by tsltz) as lead from tz_test order by 1, 2;
select id, tsltz, lead(tsltz, 2) over(order by tstz) as lead from tz_test order by 1, 2;
select gid, tstz, lead(tstz, 1) over(partition by gid order by ts desc) as lead from tz_test order by 1, 2 desc;

select gid, max(ts) over() max_ts, max(tsltz) over(partition by gid) max_tsltz, max(tstz) over(partition by gid order by id desc) max_tstz from tz_test order by gid, 2, 3;

select id, ts, median(ts) over() median from tz_test order by 1;
--BUG: CUBRIDSUS-16435
select gid, tstz, median(tstz) over(partition by gid) median from tz_test;
select gid, tsltz, median(tsltz) over(partition by gid, tsltz) median from tz_test;
 
select gid, tstz, min(ts) over() min_ts, min(tsltz) over(partition by gid) min_tsltz, min(tstz) over(partition by gid order by id desc) min_tstz from tz_test order by gid, 2, 3;

select id, ts, nth_value(ts, 2) ignore nulls over(order by tsltz) nv from tz_test; 
select id, tsltz, nth_value(tsltz, 2) over(order by id desc) nv from tz_test; 
select gid, tstz, nth_value(tstz, 2) over(partition by gid order by id) nv from tz_test; 

select id, ts, ntile(3) over(order by ts) n_group from tz_test;
select id, tsltz, ntile(4) over(order by tsltz desc) n_group from tz_test;
select id, tstz, ntile(2) over(partition by gid order by tstz) n_group from tz_test;

select id, ts, percent_rank() over(order by ts) as prank from tz_test; 
select id, tstz, percent_rank() over(order by tstz desc) as prank from tz_test; 
select gid, tsltz, percent_rank() over(partition by gid order by tsltz desc) as prank from tz_test; 

select id, ts, rank() over(order by ts) rank from tz_test;
select id, tsltz, rank() over(order by tsltz desc) rank from tz_test;
select gid, tstz, rank() over(partition by gid order by tstz) rank from tz_test;

drop table tz_test;


set timezone 'Asia/Seoul';
