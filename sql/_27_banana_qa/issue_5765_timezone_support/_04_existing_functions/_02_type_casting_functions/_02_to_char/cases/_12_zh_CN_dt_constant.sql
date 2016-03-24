--test to_char function with DATETIME(L)TZ constant values, with zh_CN language + session variables
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';


set system parameters 'intl_date_lang=zh_CN';
set names utf8;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

--test: new tokens, with constant
set @v1=datetime'2025-12-31 22:30:45.999';
set @v2=datetimetz'2025-12-31 22:30:45.999 -2:25';
set @v3=datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo';

select to_char(@v1, 'TZR') ts, to_char(@v2, 'TZR') dttz1, to_char(@v3, 'TZR') dttz2;
select to_char(@v1, 'TZR TZD') ts, to_char(@v2, 'TZR TZD') dttz1, to_char(@v3, 'TZR TZD') dttz2;
select to_char(@v1, 'TZH') ts, to_char(@v2, 'TZH') dttz1, to_char(@v3, 'TZH') dttz2;
select to_char(@v1, 'TZH:TZM') ts, to_char(@v2, 'TZH:TZM') dttz1, to_char(@v3, 'TZH:TZM') dttz2;
--test: [er] unsupported combination
select to_char(@v1, 'TZH TZR') ts;
select to_char(@v2, 'TZD:TZM');
select to_char(@v1, 'TZH:TZM TZR TZD');

--test: with HV, default format
prepare st from 'select to_char(?)';

execute st using @v1;
execute st using @v2;
execute st using @v3;

--test: with format argument
prepare st from 'select to_char(?, ?)';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M.';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR TZD';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';

execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M.';
execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR TZD';
execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH';
execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';

execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M.';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZD';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR TZD';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM TZR';

set time zone '-6:23';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZD';
execute st using @v1, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';
execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR TZD';
execute st using @v2, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZR TZD';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH';
execute st using @v3, 'CC, YY/MM/DD HH:MI:SS.FF A.M. TZH:TZM';

set time zone 'America/Mexico_City';
-- -6:00, DST
set @v1=datetime'2014-06-30 7:30:21.999 PM';
set @v2=datetimetz'2014-06-30 7:30:21.999 PM +10:30';
set @v3=datetimetz'2014-06-30 7:30:21.999 PM America/New_York';

execute st using @v1, 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using @v1, 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using @v1, 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using @v1, 'DD"th", YYYY; DY/d HH24:MI:SS TZH';
execute st using @v1, 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM';

execute st using @v2, 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using @v2, 'DD"th", YYYY; DY/d HH24:MI:SS TZD';
execute st using @v2, 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using @v2, 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TZM';
execute st using @v2, 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZM';

execute st using @v3, 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using @v3, 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using @v3, 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using @v3, 'DD"th", YYYY; DY/d HH24:MI:SS TZM';
execute st using @v3, 'DD"th", YYYY; DY/d HH24:MI:SS TZH:TRM';

set time zone 'Asia/Shanghai';
set @v1='2014-06-30 7:30:21.999';
set @v2='2014-06-30 7:30:21.999 +10:00';
set @v3='2014-06-30 7:30:21.999 Asia/Seoul';

--test: with date_lang_string_literal argument
set system parameters 'intl_date_lang=ko_KR';
prepare st from 'select to_char(?, ?, ''zh_CN'')';

execute st using @v1, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM';
execute st using @v1, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR';
execute st using @v1, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD';
execute st using @v1, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH';
execute st using @v1, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM';

execute st using @v2, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM';
execute st using @v2, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR';
execute st using @v2, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD';
execute st using @v2, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH';
execute st using @v2, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM';

execute st using @v3, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM';
execute st using @v3, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR';
execute st using @v3, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD';
execute st using @v3, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH';
execute st using @v3, 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM';


--test: leap seconds
set time zone 'Europe/London';
-- 0:00, DST
set @v1='2009-01-01 12:59:59.999 AM';
set @v2='2008-12-31 23:59:59.999 UTC';
set @v3='2009-01-01 12:59:59.999 AM Europe/London';

execute st using @v1+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR';
execute st using @v1+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD';
execute st using @v1+1, 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM';
execute st using @v1+1, 'MM/DD/YYYY HH24:MI:SS.FF TZD';

execute st using @v2+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR';
execute st using @v2+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD';
execute st using @v2+1, 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM';
execute st using @v2+1, 'MM/DD/YYYY HH24:MI:SS.FF TZD';

execute st using @v3+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR';
execute st using @v3+1, 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD';
execute st using @v3+1, 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM';
execute st using @v3+1, 'MM/DD/YYYY HH24:MI:SS.FF TZD';


deallocate prepare st;
drop variable @v1, @v2, @v3;

set time zone '+0:00';
set system parameters 'intl_date_lang=en_US';
set names iso88591;
set system parameters 'tz_leap_second_support=no';

--+ holdcas off;
