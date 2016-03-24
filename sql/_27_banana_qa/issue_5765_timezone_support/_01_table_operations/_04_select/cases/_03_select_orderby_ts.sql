--test TIMESTAMP(L)Tz columns with same time values but different time zone values, check the order

set timezone 'UTC';

drop table if exists tz_test;
create table tz_test(id int primary key auto_increment, col1 timestamp with time zone, col2 timestamp with local time zone);

insert into tz_test(col1, col2) values(timestamptz'2000-02-01 13:00:00 Asia/Yerevan', timestamptz'2000-02-01 13:00:00 Asia/Yerevan');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 13:00:00 Asia/Baku', timestamptz'2000-02-01 13:00:00 Asia/Baku');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 12:00:00 PM Asia/Bahrain', timestamptz'2000-02-01 12:00:00 PM Asia/Bahrain');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 15:00:00 Asia/Dhaka', timestamptz'2000-02-01 15:00:00 Asia/Dhaka');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 15:00:00 Asia/Thimphu', timestamptz'2000-02-01 15:00:00 Asia/Thimphu');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 17:00:00 Asia/Brunei', timestamptz'2000-02-01 17:00:00 Asia/Brunei');

insert into tz_test(col1, col2) values(timestamptz'2000-02-01 20:00:00 Australia/Hobart', timestamptz'2000-02-01 20:00:00 Australia/Hobart');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 20:00:00 Australia/Currie', timestamptz'2000-02-01 20:00:00 Australia/Currie');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 20:00:00 Australia/Lord_Howe', timestamptz'2000-02-01 20:00:00 Australia/Lord_Howe');

insert into tz_test(col1, col2) values(timestamptz'2000-02-01 10:00:00 Africa/Algiers', timestamptz'2000-02-01 10:00:00 Africa/Algiers');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 11:00:00 Africa/Bujumbura', timestamptz'2000-02-01 11:00:00 Africa/Bujumbura');
insert into tz_test(col1, col2) values(timestamptz'2000-02-01 10:00:00 Africa/Brazzaville', timestamptz'2000-02-01 10:00:00 Africa/Brazzaville');


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















