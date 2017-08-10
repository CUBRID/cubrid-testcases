select tz_offset('+05:00');
select tz_offset('Asia/Seoul');
select tz_offset('Asia/Bahrain');
select tz_offset('Africa/Douala');
select tz_offset('inexistent');
select tz_offset('-01:00');
select tz_offset('+05:00a');
select tz_offset('+05:00:01');
select tz_offset(+'05:00:01:01');

drop table if exists test;
create table test (a int , b string);
insert into test values(1, tz_offset('Asia/Seoul'));
insert into test values(2, tz_offset('Africa/Douala'));
insert into test values(3, tz_offset('+01:01'));
insert into test values(4, tz_offset('-23:23:23'));
select tz_offset(a) from test order by 1;
select tz_offset(b) from test order by 1;

drop test;
