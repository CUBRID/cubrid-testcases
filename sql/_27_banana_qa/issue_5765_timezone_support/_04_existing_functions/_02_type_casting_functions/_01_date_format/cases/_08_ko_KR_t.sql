--test date_format function with TIME(L)TZ columns, with ko_KR language
--+ holdcas on;


set system parameters 'intl_date_lang=ko_KR';
set names utf8;

drop table if exists tz_test;
create table tz_test(id int, ts time);

set time zone '-6:00';
insert into tz_test values(1, '22:30:45');
insert into tz_test values(2, '7:30:21 PM');
insert into tz_test values(3, '7:30:21');
insert into tz_test values(4, '23:59:59');

prepare st from 'select id, date_format(ts, ?) from tz_test order by 1';

set time zone '-12:00';
execute st using '%m/%d/%y %k:%i:%s.%f [%p] %TZR';
set time zone 'America/Sao_Paulo';
execute st using '%a, %D %b. %Y %T %TZH';

set time zone 'America/Mexico_City';
execute st using '[%r] %W(%w) %M %e, %Y %TZH:%TZM';

set time zone 'Asia/Shanghai';
execute st using '%X, %V, %U, Day %j %TZR@%TZD, %TZH:%TZM';

prepare st from 'select id, date_format(ts+1, ?) from tz_test order by 1';
set time zone 'Europe/London';
execute st using '%x, %v-%u Day %j %H:%i:%S (%TZH:%TZM) %TZR-%TZD';

deallocate prepare st;

drop table tz_test;

set timezone 'Asia/Seoul';
set names iso88591;
set system parameters 'intl_date_lang=en_US';

--+ holdcas off;
