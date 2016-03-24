--test to_char function with TIMESTAMP(L)TZ columns, with ko_KR language
--+ holdcas on;
set system parameters 'tz_leap_second_support=yes';


set system parameters 'intl_date_lang=ko_KR';
set names utf8;
drop table if exists tz_test;
create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);

set time zone 'America/Sao_Paulo';
-- -3:00, DST
insert into tz_test values(1, '2025-12-31 22:30:45', '2025-12-31 22:30:45 -2:25', '2025-12-31 22:30:45 America/Sao_Paulo');
set time zone 'America/Mexico_City';
-- -6:00, DST
insert into tz_test values(2, timestamp'2014-06-30 7:30:21 PM', timestamptz'2014-06-30 7:30:21 PM +10:30', timestamptz'2014-06-30 7:30:21 PM America/New_York');
set time zone 'Asia/Shanghai';
insert into tz_test values(3, '2014-06-30 7:30:21', '2014-06-30 7:30:21 +10:00', '2014-06-30 7:30:21 Asia/Seoul');
set time zone 'Europe/London';
-- 0:00, DST
insert into tz_test values(4, '2009-01-01 12:59:59 AM', '2008-12-31 23:59:59 UTC', '2009-01-01 12:59:59 AM Europe/London');

set time zone 'America/Sao_Paulo';
-- -3:00, DST
--test: new tokens
select id, to_char(ts, 'TZR') ts, to_char(tsltz, 'TZR') tstz1, to_char(tstz, 'TZR') tstz2 from tz_test order by id;
select id, to_char(ts, 'TZR TZD') ts, to_char(tsltz, 'TZR TZD') tstz1, to_char(tstz, 'TZR TZD') tstz2 from tz_test order by id;
select id, to_char(ts, 'TZH') ts, to_char(tsltz, 'TZH') tstz1, to_char(tstz, 'TZH') tstz2 from tz_test order by id;
select id, to_char(ts, 'TZH:TZM') ts, to_char(tsltz, 'TZH:TZM') tstz1, to_char(tstz, 'TZH:TZM') tstz2 from tz_test order by id;
--test: [er] unsupported combination
select id, to_char(ts, 'TZH TZR') ts from tz_test order by id;
select id, to_char(tsltz, 'TZD:TZM') from tz_test order by id;
select id, to_char(ts, 'TZH:TZM TZR TZD') from tz_test order by id;

--test: default format
select id, to_char(ts), to_char(tsltz), to_char(tstz) from tz_test order by 1;

--test: ps, with format argument
prepare st from 'select id, to_char(ts, ?), to_char(tsltz, ?), to_char(tstz, ?) from tz_test order by 1';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M.', 'CC, YY/MM/DD HH:MI:SS A.M.', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZR', 'CC, YY/MM/DD HH:MI:SS A.M. TZR', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';

set time zone '-6:23';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZR', 'CC, YY/MM/DD HH:MI:SS A.M. TZR', 'CC, YY/MM/DD HH:MI:SS A.M. TZR';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZD';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM', 'CC, YY/MM/DD HH:MI:SS A.M. TZH:TZM';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD', 'CC, YY/MM/DD HH:MI:SS A.M. TZR TZD';

set time zone 'America/Mexico_City';
-- -6:00, DST
execute st using 'DD"th", YYYY; DY/d HH24:MI:SS', 'DD"th", YYYY; DY/d HH24:MI:SS', 'DD"th", YYYY; DY/d HH24:MI:SS';
execute st using 'DD"th", YYYY; DY/d HH24:MI:SS TZR', 'DD"th", YYYY; DY/d HH24:MI:SS TZR', 'DD"th", YYYY; DY/d HH24:MI:SS TZR';
execute st using 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD', 'DD"th", YYYY; DY/d HH24:MI:SS TZR TZD';
execute st using 'DD"th", YYYY; DY/d HH24:MI:SS TZH', 'DD"th", YYYY; DY/d HH24:MI:SS TZH', 'DD"th", YYYY; DY/d HH24:MI:SS TZH';
execute st using 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM', 'DD"th", YYYY; DY/d HH24:MI:SS TZH TZM';

set time zone 'Asia/Shanghai';
--test: with date_lang_string_literal argument
set system parameters 'intl_date_lang=km_KH';
prepare st from 'select id, to_char(ts, ?, ''ko_KR''), to_char(tsltz, ?, ''ko_KR''), to_char(tstz, ?, ''ko_KR'') from tz_test order by 1';

execute st using 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM';
execute st using 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR';
execute st using 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZR TZD';
execute st using 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH';
execute st using 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM', 'YYYY "Quarter " Q, MONTH-DD DAY HH:MI:SS.FF PM TZH:TZM';


--test: leap seconds
set time zone 'Europe/London';
-- 0:00, DST
prepare st from 'select id, to_char(ts+1, ?, ''ko_KR''), to_char(tsltz+1, ?, ''ko_KR''), to_char(tstz+1, ?, ''ko_KR'') from tz_test order by 1';

execute st using 'MM/DD/YYYY HH24:MI:SS.FF TZR', 'MM/DD/YYYY HH24:MI:SS.FF TZR', 'MM/DD/YYYY HH24:MI:SS.FF TZR';
execute st using 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD', 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD', 'MM/DD/YYYY HH24:MI:SS.FF TZR;TZD';
execute st using 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM', 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM', 'MM/DD/YYYY HH24:MI:SS.FF TZH:TZM';
execute st using 'MM/DD/YYYY HH24:MI:SS.FF TZD', 'MM/DD/YYYY HH24:MI:SS.FF TZD', 'MM/DD/YYYY HH24:MI:SS.FF TZD';


deallocate prepare st;
drop table tz_test;

set time zone '+0:00';
set system parameters 'intl_date_lang=en_US';
set names iso88591;
set system parameters 'tz_leap_second_support=no';

--+ holdcas off;
