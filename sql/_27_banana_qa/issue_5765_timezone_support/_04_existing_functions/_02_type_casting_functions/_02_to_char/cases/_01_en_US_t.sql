--test to_char function with TIME(L)TZ columns, with en_US language
--+ holdcas on;

set system parameters 'intl_date_lang=en_US';

drop table if exists tz_test;
create table tz_test(id int primary key, ts time);

set time zone '-3:00';
insert into tz_test values(1, '22:30:45');
insert into tz_test values(2, time'7:30:21 PM');
insert into tz_test values(3, '7:30:21');
insert into tz_test values(4, '23:59:59');

--test: new tokens
select id, to_char(ts, 'TZR') ts from tz_test order by id;
select id, to_char(ts, 'TZR TZD') ts from tz_test order by id;
select id, to_char(ts, 'TZH') ts from tz_test order by id;
select id, to_char(ts, 'TZH:TZM') ts from tz_test order by id;
--test: [er] unsupported combination
select id, to_char(ts, 'TZH TZR') ts from tz_test order by id;
select id, to_char(ts, 'TZH:TZM TZR TZD') from tz_test order by id;

--test: default format
select id, to_char(ts) from tz_test order by 1;

--test: ps, with format argument
prepare st from 'select id, to_char(ts, ?) from tz_test order by 1';
execute st using 'CC, YY/MM/DD HH:MI:SS A.M.';
execute st using 'HH:MI:SS A.M. TZR';
execute st using 'HH:MI:SS A.M. TZR TZD';
execute st using 'HH:MI:SS A.M. TZH:TZM';

set time zone '-6:23';
execute st using 'HH:MI:SS A.M. TZR';
execute st using 'HH:MI:SS A.M. TZD';
execute st using 'HH:MI:SS A.M. TZH:TZM';
execute st using 'HH:MI:SS A.M. TZR TZD';

set time zone 'America/Hermosillo';
execute st using 'HH24:MI:SS';
execute st using 'HH24:MI:SS TZR';
execute st using 'HH24:MI:SS TZR TZD';
execute st using 'HH24:MI:SS TZH';
execute st using 'HH24:MI:SS TZH TZM';

set time zone 'Asia/Makassar';
--test: with date_lang_string_literal argument
set system parameters 'intl_date_lang=ko_KR';
prepare st from 'select id, to_char(ts, ?, ''en_US'') from tz_test order by 1';

execute st using 'HH:MI:SS PM';
execute st using 'HH:MI:SS PM TZR';
execute st using 'HH:MI:SS PM TZR TZD';
execute st using 'HH:MI:SS PM TZH';
execute st using 'HH:MI:SS PM TZH:TZM';


set time zone 'Asia/Shanghai';
prepare st from 'select id, to_char(ts+1, ?, ''en_US'') from tz_test order by 1';

execute st using 'HH24:MI:SS TZR';
execute st using 'HH24:MI:SS TZR;TZD';
execute st using 'HH24:MI:SS TZH:TZM';
execute st using 'HH24:MI:SS TZD';


deallocate prepare st;
drop table tz_test;

set timezone 'Asia/Seoul';
set system parameters 'intl_date_lang=en_US';
set names iso88591;

--+ holdcas off;
