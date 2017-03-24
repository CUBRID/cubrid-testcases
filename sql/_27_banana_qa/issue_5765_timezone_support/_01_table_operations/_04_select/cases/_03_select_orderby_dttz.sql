--test DATETIMETZ column, with order by clause
set system parameters 'tz_leap_second_support=yes';

drop table if exists tz_test;

create table tz_test(id int primary key auto_increment, col1 datetime with time zone not null default datetimetz'2014-09-01 2:00:20.999 Asia/Shanghai', col2 datetime with time zone);

set timezone '+14:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Pacific/Niue');
set timezone '+12:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Pacific/Tahiti');
set timezone '+10:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 8:12:56.999 PM America/Vancouver');
set timezone '+08:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Pacific/Pitcairn');
set timezone '+06:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM America/Tijuana');
set timezone '+04:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM America/Noronha -02');
set timezone '+02:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM CET');
set timezone '-00:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Indian/Comoro');
set timezone '-1:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Asia/Aqtobe');
set timezone '-3:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Asia/Vientiane');
set timezone '-5:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Asia/Dili +09');
set timezone '-7:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Asia/Vladivostok');
set timezone '-9:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Pacific/Enderbury');
set timezone '-11:00';
insert into tz_test(col1, col2) values(datetimetz'2945-05-12 9:12:56.999 PM', datetimetz'2945-05-12 9:12:56.999 PM Pacific/Kiritimati');


--leap second
set timezone 'UTC';
insert into tz_test(col1, col2) values(datetimetz'1994-6-30 23:59:59.999', datetimetz'1994-6-30 23:59:59.999');
insert into tz_test(col1, col2) values(datetimetz'1994-6-30 23:59:59.999'+1, datetimetz'1994-6-30 23:59:59.999'+1);


--test: order by
select id, col1 from tz_test order by col1, id desc;
select id, col2 from tz_test order by col2, id asc;
set timezone '+10:00';
select id, col1 from tz_test order by col1 desc, id;
select id, col2 from tz_test order by col2 desc, id desc;
set timezone 'Asia/Aqtobe';
select * from tz_test order by col1, col2, id;
select * from tz_test order by col2 desc, col1 asc, id desc;
select * from tz_test order by col1 desc, col2 asc limit 5;
select * from tz_test order by col1 desc, col1 asc;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
