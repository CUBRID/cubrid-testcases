--test to_char function with DATETIME(L)TZ constant values, with es_ES language
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';


set system parameters 'intl_date_lang=es_ES';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

--test: new tokens, with constant
select to_char(datetime'2025-12-31 22:30:45.999', 'TZR') ts, to_char(datetimeltz'2025-12-31 22:30:45.999 -2:25', 'TZR') dttz1, to_char(datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'TZR') dttz2;
select to_char(datetime'2025-12-31 22:30:45.999', 'TZR TZD') ts, to_char(datetimeltz'2025-12-31 22:30:45.999 -2:25', 'TZR TZD') dttz1, to_char(datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'TZR TZD') dttz2;
select to_char(datetime'2025-12-31 22:30:45.999', 'TZH') ts, to_char(datetimeltz'2025-12-31 22:30:45.999 -2:25', 'TZH') dttz1, to_char(datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'TZH') dttz2;
select to_char(datetime'2025-12-31 22:30:45.999', 'TZH:TZM') ts, to_char(datetimeltz'2025-12-31 22:30:45.999 -2:25', 'TZH:TZM') dttz1, to_char(datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'TZH:TZM') dttz2;
--test: unsupported combination
select to_char(datetime'2025-12-31 22:30:45.999', 'TZH TZR') ts;
select to_char(datetimeltz'2025-12-31 22:30:45.999 -2:25', 'TZD:TZM');
select to_char(datetime'2025-12-31 22:30:45.999', 'TZH:TZM TZR TZD');

--test: with HV, default format
prepare st from 'select to_char(?)';

execute st using datetime'2025-12-31 22:30:45.999';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo';

--test: with format argument
prepare st from 'select to_char(?, ?)';
--BUG: CUBRIDSUS-15365
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZD';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM TZR';

set time zone '-6:23';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZD';
execute st using datetime'2025-12-31 22:30:45.999', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using datetimeltz'2025-12-31 22:30:45.999 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH';
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using datetime'2014-06-30 7:30:21.999 PM', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using datetime'2014-06-30 7:30:21.999 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using datetime'2014-06-30 7:30:21.999 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using datetime'2014-06-30 7:30:21.999 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH';
execute st using datetime'2014-06-30 7:30:21.999 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM';

execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZD';
execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TZM';
execute st using datetimetz'2014-06-30 7:30:21.999 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZM';

execute st using datetimetz'2014-06-30 7:30:21.999 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using datetimetz'2014-06-30 7:30:21.999 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using datetimetz'2014-06-30 7:30:21.999 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using datetimetz'2014-06-30 7:30:21.999 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZM';
execute st using datetimetz'2014-06-30 7:30:21.999 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TZM';

set time zone 'Asia/Shanghai';
--test: with date_lang_string_literal argument
prepare st from 'select to_char(?, ?, ''es_ES'')';

execute st using datetimeltz'2014-06-30 7:30:21.999', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using datetimeltz'2014-06-30 7:30:21.999', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using datetimeltz'2014-06-30 7:30:21.999', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using datetimeltz'2014-06-30 7:30:21.999', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using datetimeltz'2014-06-30 7:30:21.999', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';

execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using datetimetz'2014-06-30 7:30:21.999 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';

execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using datetimetz'2014-06-30 7:30:21.999 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';


--test: leap seconds
prepare st from 'select to_char(?+1, ?, ''es_ES'')';
set time zone 'Europe/London';
-- 0:00, DST
execute st using datetime'2008-12-31 23:59:59.999', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using datetime'2008-12-31 23:59:59.999', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using datetime'2008-12-31 23:59:59.999', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using datetime'2008-12-31 23:59:59.999', 'MM/DD/YYYY HH24:MI:SS TZD';

execute st using datetimetz'2008-12-31 23:59:59.999 UTC', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using datetimetz'2008-12-31 23:59:59.999 UTC', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using datetimetz'2008-12-31 23:59:59.999 UTC', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using datetimetz'2008-12-31 23:59:59.999 UTC', 'MM/DD/YYYY HH24:MI:SS TZD';

execute st using datetimeltz'2008-12-31 23:59:59.999 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using datetimetz'2008-12-31 23:59:59.999 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using datetimeltz'2008-12-31 23:59:59.999 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using datetimetz'2008-12-31 23:59:59.999 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZD';


deallocate prepare st;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;
set system parameters 'tz_leap_second_support=no';

--+ holdcas off;
