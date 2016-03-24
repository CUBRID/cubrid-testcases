--test to_char function with TIMESTAMP(L)TZ constant values, with de_DE language
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';


set system parameters 'intl_date_lang=de_DE';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

--test: new tokens, with constant
select to_char(timestamp'2025-12-31 22:30:45', 'TZR') ts, to_char(timestampltz'2025-12-31 22:30:45 -2:25', 'TZR') tstz1, to_char(timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'TZR') tstz2;
select to_char(timestamp'2025-12-31 22:30:45', 'TZR TZD') ts, to_char(timestampltz'2025-12-31 22:30:45 -2:25', 'TZR TZD') tstz1, to_char(timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'TZR TZD') tstz2;
select to_char(timestamp'2025-12-31 22:30:45', 'TZH') ts, to_char(timestampltz'2025-12-31 22:30:45 -2:25', 'TZH') tstz1, to_char(timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'TZH') tstz2;
select to_char(timestamp'2025-12-31 22:30:45', 'TZH:TZM') ts, to_char(timestampltz'2025-12-31 22:30:45 -2:25', 'TZH:TZM') tstz1, to_char(timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'TZH:TZM') tstz2;
--test: unsupported combination
select to_char(timestamp'2025-12-31 22:30:45', 'TZH TZR') ts;
select to_char(timestampltz'2025-12-31 22:30:45 -2:25', 'TZD:TZM');
select to_char(timestamp'2025-12-31 22:30:45', 'TZH:TZM TZR TZD');

--test: with HV, default format
prepare st from 'select to_char(?)';

execute st using timestamp'2025-12-31 22:30:45';
execute st using timestampltz'2025-12-31 22:30:45 -2:25';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo';

--test: with format argument
prepare st from 'select to_char(?, ?)';
--BUG: CUBRIDSUS-15365
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH';
execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZD';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM TZR';

set time zone '-6:23';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZD';
execute st using timestamp'2025-12-31 22:30:45', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using timestampltz'2025-12-31 22:30:45 -2:25', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH';
execute st using timestamptz'2025-12-31 22:30:45 America/Sao_Paulo', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using timestamp'2014-06-30 7:30:21 PM', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using timestamp'2014-06-30 7:30:21 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using timestamp'2014-06-30 7:30:21 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using timestamp'2014-06-30 7:30:21 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH';
execute st using timestamp'2014-06-30 7:30:21 PM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM';

execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZD';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TZM';
execute st using timestamptz'2014-06-30 7:30:21 PM +10:30', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZM';

execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZM';
execute st using timestamptz'2014-06-30 7:30:21 PM America/New_York', 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TZM';

set time zone 'Asia/Shanghai';
--test: with date_lang_string_literal argument
prepare st from 'select to_char(?, ?, ''de_DE'')';

execute st using timestampltz'2014-06-30 7:30:21', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using timestampltz'2014-06-30 7:30:21', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using timestampltz'2014-06-30 7:30:21', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using timestampltz'2014-06-30 7:30:21', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using timestampltz'2014-06-30 7:30:21', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';

execute st using timestamptz'2014-06-30 7:30:21 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using timestamptz'2014-06-30 7:30:21 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using timestamptz'2014-06-30 7:30:21 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using timestamptz'2014-06-30 7:30:21 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using timestamptz'2014-06-30 7:30:21 +10:00', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';

execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZR TZD';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH';
execute st using timestamptz'2014-06-30 7:30:21 Asia/Seoul', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS PM TZH:TZM';


--test: leap seconds
prepare st from 'select to_char(?+1, ?, ''de_DE'')';
set time zone 'Europe/London';
-- 0:00, DST
execute st using timestamp'2008-12-31 23:59:59', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using timestamp'2008-12-31 23:59:59', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using timestamp'2008-12-31 23:59:59', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using timestamp'2008-12-31 23:59:59', 'MM/DD/YYYY HH24:MI:SS TZD';

execute st using timestamptz'2008-12-31 23:59:59 UTC', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using timestamptz'2008-12-31 23:59:59 UTC', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using timestamptz'2008-12-31 23:59:59 UTC', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using timestamptz'2008-12-31 23:59:59 UTC', 'MM/DD/YYYY HH24:MI:SS TZD';

execute st using timestampltz'2008-12-31 23:59:59 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZR';
execute st using timestamptz'2008-12-31 23:59:59 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZR;TZD';
execute st using timestampltz'2008-12-31 23:59:59 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZH:TZM';
execute st using timestamptz'2008-12-31 23:59:59 Europe/London', 'MM/DD/YYYY HH24:MI:SS TZD';


deallocate prepare st;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;
set system parameters 'tz_leap_second_support=no';

--+ holdcas off;
