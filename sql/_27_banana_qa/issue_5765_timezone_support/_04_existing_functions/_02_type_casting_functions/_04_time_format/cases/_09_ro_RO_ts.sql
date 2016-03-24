--test time_format function with TIMESTAMP(L)TZ columns, with ro_RO language
--+ holdcas on;


set system parameters 'intl_date_lang=ro_RO';
set names utf8;

drop table if exists tz_test;
create table tz_test(id int, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set time zone 'America/Sao_Paulo';
-- -3:00, DST
insert into tz_test values(1, '2025-12-31 22:30:45', '2025-12-31 22:30:45 -2:00', '2025-12-31 22:30:45 America/Sao_Paulo');
set time zone 'America/Mexico_City';
-- -6:00, DST
insert into tz_test values(2, '2014-06-30 7:30:21 PM', '2014-06-30 7:30:21 PM America/New_York', '2014-06-30 7:30:21 PM +10:45');
set time zone 'Asia/Shanghai';
insert into tz_test values(3, '2014-06-30 7:30:21', '2014-06-30 7:30:21 +10:00', '2014-06-30 7:30:21 Asia/Seoul');
set time zone 'Europe/London';
-- 0:00
insert into tz_test values(4, '2008-12-31 23:59:59', '2008-12-31 23:59:59 UTC', '2008-12-31 23:59:59 Europe/London');

prepare st from 'select id, time_format(ts, ?), time_format(tsltz, ?), time_format(tstz, ?) from tz_test order by 1';

set time zone '-12:00';
execute st using '%m/%d/%y %k:%i:%s.%f [%p] %TZR', '%m/%d/%y %k:%i:%s.%f [%p] %TZD', '%m/%d/%y %k:%i:%s.%f [%p] %TZR-%TZD';
set time zone 'America/Sao_Paulo';
-- -3:00, DST
execute st using '%a, %D %b. %Y %T %TZH', '%a, %D %b. %Y %T %TZM', '%a, %D %b. %Y %T %TZH:%TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using '[%r] %W(%w) %M %e, %Y %TZH:%TZM', '[%r] %W(%w) %M %e, %Y %TZR (%TZH)', '[%r] %W(%w) %M %e, %Y %TZR (%TZH)';

set time zone 'Asia/Shanghai';
execute st using '%X, %V, %U, Day %j %TZR@%TZD, %TZH:%TZM', '%X, %V, %U, Day %j %TZR@%TZD, %TZH:%TZM', '%X, %V, %U, Day %j %TZR@%TZD, %TZH:%TZM';

prepare st from 'select id, time_format(ts+1, ?), time_format(tsltz+1, ?), time_format(tstz+1, ?) from tz_test order by 1';
set time zone 'Europe/London';
-- 0:00, DST
execute st using '%x, %v-%u Day %j %H:%i:%S (%TZH:%TZM) %TZR-%TZD', '%x, %v-%u Day %j %H:%i:%S (%TZH:%TZM) %TZR-%TZD', '%x, %v-%u Day %j %H:%i:%S (%TZH:%TZM) %TZR-%TZD';

deallocate prepare st;

drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
