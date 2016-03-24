--test to_char function with TIMESTAMP(L)TZ constant values, with ko_KR language + session variables
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';


set system parameters 'intl_date_lang=ko_KR';
set names euckr;

set time zone 'America/Sao_Paulo';
-- -3:00, DST

--test: new tokens, with constant
set @v1=timestamp'2025-12-31 22:30:45';
set @v2=timestamptz'2025-12-31 22:30:45 -2:25';
set @v3=timestamptz'2025-12-31 22:30:45 America/Sao_Paulo';

select to_char(@v1, 'TZR') ts, to_char(@v2, 'TZR') tstz1, to_char(@v3, 'TZR') tstz2;
select to_char(@v1, 'TZR TZD') ts, to_char(@v2, 'TZR TZD') tstz1, to_char(@v3, 'TZR TZD') tstz2;
select to_char(@v1, 'TZH') ts, to_char(@v2, 'TZH') tstz1, to_char(@v3, 'TZH') tstz2;
select to_char(@v1, 'TZH:TZM') ts, to_char(@v2, 'TZH:TZM') tstz1, to_char(@v3, 'TZH:TZM') tstz2;
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
set @v1=timestamp'2014-06-30 7:30:21 PM';
set @v2=timestamptz'2014-06-30 7:30:21 PM +10:30';
set @v3=timestamptz'2014-06-30 7:30:21 PM America/New_York';

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
set @v1='2014-06-30 7:30:21';
set @v2='2014-06-30 7:30:21 +10:00';
set @v3='2014-06-30 7:30:21 Asia/Seoul';

--test: with date_lang_string_literal argument
set system parameters 'intl_date_lang=ja_JP';
prepare st from 'select to_char(?, ?, ''ko_KR'')';

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
set @v1='2009-01-01 12:59:59 AM';
set @v2='2008-12-31 23:59:59 UTC';
set @v3='2009-01-01 12:59:59 AM Europe/London';

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
