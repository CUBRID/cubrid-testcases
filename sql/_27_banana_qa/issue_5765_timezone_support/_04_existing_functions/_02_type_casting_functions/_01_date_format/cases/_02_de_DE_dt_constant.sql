--test date_format function with DATETIME(L)TZ constant values, with de_DE language
--+ holdcas on;


set system parameters 'tz_leap_second_support=yes';
set system parameters 'intl_date_lang=de_DE';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

prepare st from 'select date_format(?, ?)';

execute st using datetimeltz'2025-12-31 22:30:45.999', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';
execute st using datetimetz'2025-12-31 22:30:45.999 -2:00', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';

execute st using datetimetz'2025-12-31 22:30:45.999', '%a, %D %b. %Y %T %TZH:%TZM';
execute st using datetimeltz'2025-12-31 22:30:45.999 +6:00', '%a, %D %b. %Y %T %TZH:%TZM';
execute st using datetimetz'2025-12-31 22:30:45.999 America/New_York', '%a, %D %b. %Y %T %TZH:%TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using datetimetz'2014-06-30 7:30:21.999 PM', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';
execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';
execute st using datetimeltz'2014-06-30 7:30:21.999 PM America/New_York', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';

--BUG: CUBRIDSUS-15023, resolved
set time zone 'Asia/Shanghai';
execute st using datetimeltz'2014-06-30 7:30:21.999', '%X, %V, %U, Day %j %TZD %TZM';
execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', '%X, %V, %U, Day %j %TZD %TZM';
execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', '%X, %V, %U, Day %j %TZD %TZM';

prepare st from 'select date_format(?+1, ?)';
set time zone 'Europe/London';
-- 0:00, DST
execute st using datetime'2009-01-01 12:59:59.999 AM', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';
execute st using datetimeltz'2008-12-31 23:59:59.999 UTC', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';
--BUG: CUBRIDSUS-15307, resolved
execute st using datetimetz'2009-01-01 12:59:59.999 AM Europe/London', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';

deallocate prepare st;

set timezone 'Asia/Seoul';
set names iso88591;
set system parameters 'tz_leap_second_support=no';
set system parameters 'intl_date_lang=en_US';

--+ holdcas off;
