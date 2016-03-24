--test time_format function with TIMESTAMP(L)TZ constant values, with ko_KR language + session variables
--+ holdcas on;


set system parameters 'intl_date_lang=ko_KR';
set names euckr;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

prepare st from 'select time_format(?, ?)';

set @v1=timestamp'2025-12-31 22:30:45';
set @v2=timestampltz'2025-12-31 22:30:45 -2:00';
set @v3=timestamptz'2025-12-31 22:30:45 America/Sao_Paulo';

execute st using @v1, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';
execute st using @v2, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';
execute st using @v3, '%m/%d/%y %k:%i:%s.%f [%p] *%TZR %TZH*';

execute st using timestamp'2025-12-31 22:30:45', '%a, %D %b. %Y %T $%TZR-%TZD$';
execute st using timestampltz'2025-12-31 22:30:45 -2:00', '%a, %D %b. %Y %T $%TZR-%TZD ($%TZH)$';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', '%a, %D %b. %Y %T $%TZR-%TZD ($%TZM)$';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using timestampltz'2014-06-30 7:30:21 PM', '[%r] %W(%w) %M %e, %Y #%TZH:%TZM#';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', '[%r] %W(%w) %M %e, %Y @@$%TZR-%TZD #%TZH:%TZM#@@';
execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', '[%r] %W(%w) %M %e, %Y #%TZH:%TZM#';

set time zone 'Asia/Shanghai';
execute st using timestampltz'2014-06-30 7:30:21', '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';
execute st using timestampltz'2014-06-30 7:30:21 +10:00', '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', '%X, %V, %U, Day %j !(%TZH:%TZM) %TZR==%TZD!';

set time zone 'Europe/London';
-- 0:00, DST
prepare st from 'select time_format(?+1, ?)';
execute st using timestampltz'2009-01-01 12:59:59 AM', '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';
execute st using timestamptz'2008-12-31 23:59:59 UTC', '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';
execute st using timestamptz'2009-01-01 12:59:59 AM Europe/London', '%x, %v-%u Day %j %H:%i:%S &&%TZR-%TZD [%TZH:%TZM] &&';

deallocate prepare st;
drop variable @v1, @v2, @v3;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
