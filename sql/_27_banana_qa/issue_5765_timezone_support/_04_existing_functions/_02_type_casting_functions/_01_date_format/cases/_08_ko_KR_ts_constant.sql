--test date_format function with TIMESTAMP(L)TZ constant values, with ko_KR language + session variables
--+ holdcas on;


set system parameters 'tz_leap_second_support=yes';
set system parameters 'intl_date_lang=ko_KR';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

prepare st from 'select date_format(?, ?)';

set @v1=timestamp'2025-12-31 22:30:45';
set @v2=timestampltz'2025-12-31 22:30:45 -2:00';
set @v3=timestamptz'2025-12-31 22:30:45 America/Sao_Paulo';

execute st using @v1, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';
execute st using @v2, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';
execute st using @v3, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';

execute st using @v1, '%a, %D %b. %Y %T $%TZR-%TZD$';
execute st using @v2, '%a, %D %b. %Y %T $%TZR-%TZD ($%TZH)$';
execute st using @v3, '%a, %D %b. %Y %T $%TZR-%TZD ($%TZM)$';

set time zone 'America/Mexico_City';
-- -6:00, DST
set @v1=timestampltz'2014-06-30 7:30:21 PM';
set @v2=timestamptz'2014-06-30 7:30:21 PM +10:30';
set @v3=timestamptz'2014-06-30 7:30:21 PM America/New_York';

execute st using @v1, '[%r] %W(%w) %M %e, %Y #%TZH:%TZM#';
execute st using @v2, '[%r] %W(%w) %M %e, %Y @@$%TZR-%TZD #%TZH:%TZM#@@';
execute st using @v3, '[%r] %W(%w) %M %e, %Y #%TZH:%TZM#';

set time zone 'Asia/Shanghai';
set @v1='2014-06-30 7:30:21';
set @v2='2014-06-30 7:30:21 -10:34';
set @v3='2014-06-30 7:30:21 Asia/Seoul';

execute st using @v1, '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';
execute st using @v2, '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';
execute st using @v3, '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';

set time zone 'Europe/London';
-- 0:00, DST
set @v1='2009-01-01 12:59:59 AM';
set @v2='2008-12-31 23:59:59 UTC';
set @v3='2009-01-01 12:59:59 AM Europe/London';

prepare st from 'select date_format(?+1, ?)';
execute st using @v1, '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';
execute st using @v2, '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';
execute st using @v3, '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';

deallocate prepare st;
drop variable @v1, @v2, @v3;

set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
