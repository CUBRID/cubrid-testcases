--test DATETIME(L)TZ columns, with prepared statement
--+ holdcas on;

drop table if exists tz_test;

set timezone 'Asia/Seoul';
create table tz_test(id int primary key auto_increment, col1 datetime with local time zone not null default datetimeltz'2014-09-01 2:00:20.999 Asia/Shanghai', col2 datetime with time zone);

--test: insert with ps
prepare st from 'insert into tz_test(col1, col2) values(datetimeltz''1938-12-10 15:30:00.999'', datetimetz''1938-12-10 15:30:00.999'')';
execute st;
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'1938-12-10 3:00:00.999 AM -03:30', datetimetz'1938-12-10 3:00:00.999 -3:30';
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'1938-12-10 8:30:00.999 Europe/Bucharest', datetimetz'1938-12-10 8:30:00.999 Europe/Riga';
deallocate prepare st;

set timezone 'Europe/Bucharest';
prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'1925-07-10 2:00:00.999', datetimetz'1925-07-10 2:00:00.999';
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'1925-07-10 3:00:00.999 Europe/Bucharest', datetimetz'1925-07-10 3:00:00.999 Europe/Bucharest';

set timezone '+2:00';
prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'1925-07-10 2:00:00.999', datetimetz'1925-07-10 2:00:00.999';
deallocate prepare st;


--test: select with ps
set timezone 'Asia/Seoul';
prepare st from 'select all * from tz_test order by id';
execute st;
deallocate prepare st;

prepare st from 'select * from tz_test where col1=? order by 1';
execute st using datetimeltz'1938-12-10 15:30:00.999 +9:00';
deallocate prepare st;

--test: where clause, normal value, col<constant value, 3 rows should be selected
set timezone '-04:30';
prepare st from 'select * from tz_test where col1>? order by 1';
execute st using datetimeltz'1938-12-10 3:00:00.999';
deallocate prepare st;

set timezone 'Australia/Perth';
prepare st from 'select * from tz_test where col2 between ? and ? order by 1';
execute st using datetimeltz'1938-12-10 15:30:00.999 +9:00', datetimetz'1936-05-12 8:12:55.999 PM';
execute st using datetimetz'1936-05-12 8:12:55.999 PM', datetimeltz'1938-12-10 15:30:00.999 +9:00';
deallocate prepare st;

--test: update to null
prepare st from 'update tz_test set col2=default where hour(col1)=hour(?)';
execute st using datetimeltz'1938-12-10 3:00:00.999 AM -03:30';
deallocate prepare st;
select * from tz_test where col2 is not null order by 1;

prepare st from 'update tz_test set col2=? where year(col1)>? order by id';
set timezone '-7:00';
execute st using datetimeltz'2015-11-20 13:14:15.999 America/New_York', 1936;
deallocate prepare st;
select col1, col2 from tz_test order by col1, col2;


drop table tz_test;


set timezone 'Asia/Seoul';

 

--+ holdcas off;
