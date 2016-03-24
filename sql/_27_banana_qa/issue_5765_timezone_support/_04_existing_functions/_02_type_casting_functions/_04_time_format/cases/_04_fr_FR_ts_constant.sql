--test time_format function with TIMESTAMP(L)TZ constant values, with fr_FR language
--+ holdcas on;


set system parameters 'intl_date_lang=fr_FR';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

prepare st from 'select time_format(?, ?)';

execute st using timestampltz'2025-12-31 22:30:45', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';
execute st using timestamptz'2025-12-31 22:30:45 -2:00', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', '%m/%d/%y %k:%i:%s.%f [%p] %TZR %TZD (%TZH)';

execute st using timestamptz'2025-12-31 22:30:45', '%a, %D %b. %Y %T %TZH:%TZM';
execute st using timestampltz'2025-12-31 22:30:45 +6:00', '%a, %D %b. %Y %T %TZH:%TZM';
execute st using timestamptz'2025-12-31 22:30:45 America/New_York', '%a, %D %b. %Y %T %TZH:%TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using timestamptz'2014-06-30 7:30:21 PM', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';
execute st using timestampltz'2014-06-30 7:30:21 PM America/New_York', '[%r] %W(%w) %M %e, %Y %TZR [%TZH]';

--BUG: CUBRIDSUS-15023, resolved
set time zone 'Asia/Shanghai';
execute st using timestampltz'2014-06-30 7:30:21', '%X, %V, %U, Day %j %TZD %TZM';
execute st using timestamptz'2014-06-30 7:30:21 +10:00', '%X, %V, %U, Day %j %TZD %TZM';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', '%X, %V, %U, Day %j %TZD %TZM';

prepare st from 'select time_format(?+1, ?)';
set time zone 'Europe/London';
-- 0:00, DST
execute st using timestamp'2009-01-01 12:59:59 AM', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';
execute st using timestampltz'2008-12-31 23:59:59 UTC', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';
--BUG: CUBRIDSUS-15307, resolved
execute st using timestamptz'2009-01-01 12:59:59 AM Europe/London', '%x, %v-%u Day %j %H:%i:%S %TZR %TZD %TZH:%TZM';

deallocate prepare st;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
