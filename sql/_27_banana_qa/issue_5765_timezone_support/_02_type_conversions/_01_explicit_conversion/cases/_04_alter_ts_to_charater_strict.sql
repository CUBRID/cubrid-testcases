--cast TIMESTAMP(L)TZ columns to character string data types, in alter statement, alter_table_change_type_strict=no

autocommit off;

drop table if exists tz_test;

create table tz_test(a int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'UTC';
insert into tz_test values(1, timestampltz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01', timestamptz'2019-01-02 12:00:01');
insert into tz_test values(2, timestampltz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00', timestamptz'2019-01-02 12:00:01 -10:00');
insert into tz_test values(3, timestampltz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00', timestamptz'2019-01-02 12:00:01 +8:00');
insert into tz_test values(4, timestampltz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo', timestamptz'2019-01-02 12:00:01 Asia/Tokyo');

commit;

set system parameters 'alter_table_change_type_strict=yes';

--test: cast ts column to character string types
alter table tz_test change ts ts char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts char(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts varchar(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change ts ts string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change ts ts enum('a', 'b', 'c');
alter table tz_test change ts ts enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tsltz column to character string types
alter table tz_test change tsltz tsltz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz char(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz varchar(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tsltz tsltz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change tsltz tsltz enum('a', 'b', 'c');
alter table tz_test change tsltz tsltz enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 Etc/UTC UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;

--test: cast tstz column to character string types
alter table tz_test change tstz tstz char(20);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz char(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz varchar(15);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz varchar(40);
desc tz_test;
select * from tz_test order by 1;
rollback;
alter table tz_test change tstz tstz string;
desc tz_test;
select * from tz_test order by 1;
rollback;
--test: [er]
alter table tz_test change tstz tstz enum('a', 'b', 'c');
alter table tz_test change tstz tstz enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 -10:00', '12:00:01 PM 01/02/2019 Asia/Tokyo', '12:00:01 PM 01/02/2019 Etc/UTC UTC');
desc tz_test;
select * from tz_test order by 1;
rollback;


drop table tz_test;
commit;

set timezone 'Asia/Seoul';
set system parameters 'alter_table_change_type_strict=no';
autocommit on;
