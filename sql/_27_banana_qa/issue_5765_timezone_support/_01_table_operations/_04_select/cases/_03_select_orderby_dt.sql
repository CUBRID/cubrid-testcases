--test DATETIME(L)Tz columns with same time values but different time zone values, check the order

set timezone 'UTC';

drop table if exists tz_test;
create table tz_test(id int primary key auto_increment, col1 datetime with time zone, col2 datetime with local time zone);

insert into tz_test(col1, col2) values(datetimetz'2000-02-01 13:00:00.999 Asia/Yerevan', datetimetz'2000-02-01 13:00:00.999 Asia/Yerevan');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 13:00:00.999 Asia/Baku', datetimetz'2000-02-01 13:00:00.999 Asia/Baku');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 12:00:00.999 PM Asia/Bahrain', datetimetz'2000-02-01 12:00:00.999 PM Asia/Bahrain');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 15:00:00.999 Asia/Dhaka', datetimetz'2000-02-01 15:00:00.999 Asia/Dhaka');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 15:00:00.999 Asia/Thimphu', datetimetz'2000-02-01 15:00:00.999 Asia/Thimphu');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 17:00:00.999 Asia/Brunei', datetimetz'2000-02-01 17:00:00.999 Asia/Brunei');

insert into tz_test(col1, col2) values(datetimetz'2000-02-01 20:00:00.999 Australia/Hobart', datetimetz'2000-02-01 20:00:00.999 Australia/Hobart');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 20:00:00.999 Australia/Currie', datetimetz'2000-02-01 20:00:00.999 Australia/Currie');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 20:00:00.999 Australia/Lord_Howe', datetimetz'2000-02-01 20:00:00.999 Australia/Lord_Howe');

insert into tz_test(col1, col2) values(datetimetz'2000-02-01 10:00:00.999 Africa/Algiers', datetimetz'2000-02-01 10:00:00.999 Africa/Algiers');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 11:00:00.999 Africa/Bujumbura', datetimetz'2000-02-01 11:00:00.999 Africa/Bujumbura');
insert into tz_test(col1, col2) values(datetimetz'2000-02-01 10:00:00.999 Africa/Brazzaville', datetimetz'2000-02-01 10:00:00.999 Africa/Brazzaville');


--test: check the ordering of tstz column
select * from tz_test order by col1, col2, id;
select col1 from tz_test order by 1;
select col1 from tz_test order by 1 desc;

--test: check the ordering of tsltz column
select * from tz_test order by col2, col1, id;
select col2 from tz_test order by 1 desc;

--test: check the ordering of ts(l)tz columns
select col1, col2 from tz_test order by col2, col1 desc;
select col1, col2 from tz_test order by col2 desc, col1 desc;



drop table tz_test;

set timezone '+00:00';















