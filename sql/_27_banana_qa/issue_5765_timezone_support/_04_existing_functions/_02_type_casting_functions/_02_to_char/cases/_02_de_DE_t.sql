--test to_char function with TIME(L)TZ columns, with de_DE language
--+ holdcas on;

set system parameters 'intl_date_lang=de_DE';
set names utf8;

drop table if exists tz_test;
create table tz_test(id int primary key, ts time, tltz time , ttz time);

set time zone '-3:00';
insert into tz_test values(1, '22:30:45', datetimeltz'2015-9-17 22:30:45 -2:25', datetimetz'2015-9-17 22:30:45 America/Porto_Velho');
insert into tz_test values(2, time'7:30:21 PM', datetimeltz'2015-9-17 7:30:21 PM +10:30', datetimetz'2015-9-17 7:30:21 PM America/Regina');
insert into tz_test values(3, '7:30:21', datetimeltz'2015-9-17 7:30:21 +10:00', datetimetz'2015-9-17 7:30:21 Asia/Seoul');
insert into tz_test values(4, '23:59:59', datetimeltz'2015-9-17 23:59:59 +00:00', datetimetz'2015-9-17 23:59:59 Africa/El_Aaiun');

--test: new tokens
select id, to_char(ts, 'TZR') ts, to_char(tltz, 'TZR') ttz1, to_char(ttz, 'TZR') ttz2 from tz_test order by id;
select id, to_char(ts, 'TZR TZD') ts, to_char(tltz, 'TZR TZD') ttz1, to_char(ttz, 'TZR TZD') ttz2 from tz_test order by id;
select id, to_char(ts, 'TZH') ts, to_char(tltz, 'TZH') ttz1, to_char(ttz, 'TZH') ttz2 from tz_test order by id;
select id, to_char(ts, 'TZH:TZM') ts, to_char(tltz, 'TZH:TZM') ttz1, to_char(ttz, 'TZH:TZM') ttz2 from tz_test order by id;
--test: [er] unsupported combination
select id, to_char(ts, 'TZH TZR') ts from tz_test order by id;
select id, to_char(tltz, 'TZD:TZM') from tz_test order by id;
select id, to_char(ts, 'TZH:TZM TZR TZD') from tz_test order by id;

--test: default format
select id, to_char(ts), to_char(tltz), to_char(ttz) from tz_test order by 1;

--test: ps, with format argument
prepare st from 'select id, to_char(ts, ?), to_char(tltz, ?), to_char(ttz, ?) from tz_test order by 1';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M.', 'CC, YY/MM/DD HH:MI:SS A.M.', 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using 'HH:MI:SS A.M. TZR', 'HH:MI:SS A.M. TZR', 'HH:MI:SS A.M. TZR';
execute st using 'HH:MI:SS A.M. TZR TZD', 'HH:MI:SS A.M. TZR TZD', 'HH:MI:SS A.M. TZR TZD';
execute st using 'HH:MI:SS A.M. TZH:TZM', 'HH:MI:SS A.M. TZH:TZM', 'HH:MI:SS A.M. TZH:TZM';

set time zone '-6:23';
execute st using 'HH:MI:SS A.M. TZR', 'HH:MI:SS A.M. TZR', 'HH:MI:SS A.M. TZR';
execute st using 'HH:MI:SS A.M. TZD', 'HH:MI:SS A.M. TZD', 'HH:MI:SS A.M. TZD';
execute st using 'HH:MI:SS A.M. TZH:TZM', 'HH:MI:SS A.M. TZH:TZM', 'HH:MI:SS A.M. TZH:TZM';
execute st using 'HH:MI:SS A.M. TZR TZD', 'HH:MI:SS A.M. TZR TZD', 'HH:MI:SS A.M. TZR TZD';

set time zone 'America/Hermosillo';
execute st using 'HH24:MI:SS', 'HH24:MI:SS', 'HH24:MI:SS';
execute st using 'HH24:MI:SS TZR', 'HH24:MI:SS TZR', 'HH24:MI:SS TZR';
execute st using 'HH24:MI:SS TZR TZD', 'HH24:MI:SS TZR TZD', 'HH24:MI:SS TZR TZD';
execute st using 'HH24:MI:SS TZH', 'HH24:MI:SS TZH', 'HH24:MI:SS TZH';
execute st using 'HH24:MI:SS TZH TZM', 'HH24:MI:SS TZH TZM', 'HH24:MI:SS TZH TZM';

set time zone 'Asia/Makassar';
--test: with date_lang_string_literal argument
set system parameters 'intl_date_lang=ko_KR';
prepare st from 'select id, to_char(ts, ?, ''de_DE''), to_char(tltz, ?, ''de_DE''), to_char(ttz, ?, ''de_DE'') from tz_test order by 1';

execute st using 'HH:MI:SS PM', 'HH:MI:SS PM', 'HH:MI:SS PM';
execute st using 'HH:MI:SS PM TZR', 'HH:MI:SS PM TZR', 'HH:MI:SS PM TZR';
execute st using 'HH:MI:SS PM TZR TZD', 'HH:MI:SS PM TZR TZD', 'HH:MI:SS PM TZR TZD';
execute st using 'HH:MI:SS PM TZH', 'HH:MI:SS PM TZH', 'HH:MI:SS PM TZH';
execute st using 'HH:MI:SS PM TZH:TZM', 'HH:MI:SS PM TZH:TZM', 'HH:MI:SS PM TZH:TZM';


set time zone 'Asia/Shanghai';
prepare st from 'select id, to_char(ts+1, ?, ''de_DE''), to_char(tltz+1, ?, ''de_DE''), to_char(ttz+1, ?, ''de_DE'') from tz_test order by 1';

execute st using 'HH24:MI:SS TZR', 'HH24:MI:SS TZR', 'HH24:MI:SS TZR';
execute st using 'HH24:MI:SS TZR;TZD', 'HH24:MI:SS TZR;TZD', 'HH24:MI:SS TZR;TZD';
execute st using 'HH24:MI:SS TZH:TZM', 'HH24:MI:SS TZH:TZM', 'HH24:MI:SS TZH:TZM';
execute st using 'HH24:MI:SS TZD', 'HH24:MI:SS TZD', 'HH24:MI:SS TZD';


deallocate prepare st;
drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
