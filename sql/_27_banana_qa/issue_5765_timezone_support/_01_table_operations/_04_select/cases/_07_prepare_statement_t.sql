--test TIME(L)TZ columns, with prepared statement
--+ holdcas on;

drop table if exists tz_test;

set timezone '+9:00';
create table tz_test(id int primary key auto_increment, col1 datetime with local time zone not null default datetimeltz'2015-9-17 2:00:20 +8:00', col2 datetime with time zone);

--test: insert with ps
prepare st from 'insert into tz_test(col1, col2) values(datetimeltz''2015-9-17 15:30:00'', datetimetz''2015-9-17 15:30:00'')';
execute st;
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'2015-9-17 3:00:00 AM -03:30', datetimetz'2015-9-17 3:00:00 -3:30';
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimetz'2015-9-17 8:30:00 America/Belem', datetimetz'2015-9-17 8:30:00 America/La_Paz';
deallocate prepare st;

set timezone 'America/Belem';
prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00';
deallocate prepare st;

prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimetz'2015-9-17 3:00:00 America/Belem', datetimetz'2015-9-17 3:00:00 America/Belem';

set timezone '+2:00';
prepare st from 'insert into tz_test(col1, col2) values(?, ?)';
execute st using datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00';
deallocate prepare st;


--test: select with ps
set timezone 'Asia/Seoul';
prepare st from 'select all * from tz_test order by id';
execute st;
deallocate prepare st;

prepare st from 'select * from tz_test where col1=? order by 1';
execute st using datetimeltz'2015-9-17 15:30:00 +9:00';
deallocate prepare st;

--test: where clause, normal value, col<constant value
set timezone '-04:30';
prepare st from 'select * from tz_test where col1>? order by 1';
execute st using datetimeltz'2015-9-17 3:00:00';
deallocate prepare st;

set timezone 'Indian/Christmas';
prepare st from 'select * from tz_test where col2 between ? and ? order by 1';
execute st using datetimeltz'2015-9-17 15:30:00 +9:00', datetimetz'2015-9-17 8:12:55 PM';
execute st using datetimetz'2015-9-17 8:12:55 PM', datetimeltz'2015-9-17 15:30:00 +9:00';
deallocate prepare st;

--test: update to null
--BUG: CUBRIDSUS-17325
prepare st from 'update tz_test set col2=default where hour(col1)=hour(?)';
execute st using datetimeltz'2015-9-17 3:00:00 AM -03:30';
deallocate prepare st;
select * from tz_test where col2 is not null order by 1;

prepare st from 'update tz_test set col2=? where minute(col1)>? order by id';
set timezone '-7:00';
execute st using datetimetz'2015-9-17 13:14:15 America/Regina', 20;
deallocate prepare st;
select col1, col2 from tz_test order by col1, col2;


drop table tz_test;


set timezone 'Asia/Seoul';

 

--+ holdcas off;
