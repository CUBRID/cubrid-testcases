--test to_time function, with en_US language
--+ holdcas on;


set system parameters 'intl_date_lang=en_US';

prepare st from 'select to_time(?, ?)';

execute st using 'Asia/Seoul CST', 'TZR TZD';

execute st using '-55', 'TZM';
execute st using '3:55', 'TZH:TZM';

prepare st from 'select to_time(?, ?, ''en_US'')';
--test: time
execute st using '05 55 58 am America/Manaus', 'HH24 MI SS AM TZR';
execute st using '05 55 58 PM America/Manaus AMT', 'HH24 MI SS AM TZR TZD';

--test: datetime
execute st using '23-10-4 23:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM';

--test: special time
--DST: non-exist time
execute st using '8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR';
execute st using '1940, Apr. 28 2:30 America/New_York EDT', 'YYYY, MON. DD HH24:MI TZR TZD';
--DST: ambiguous time
execute st using '11:00/01 PM 1993. Jan. 24 Pacific/Efate VUT', 'HH:MI/SS AM YYYY. MON. DD TZR TZD';
execute st using '11 30 59 pm Feb/26/2000 America/Fortaleza', 'HH24 MI SS AM MON/DD/YYYY TZR';


deallocate prepare st;
set timezone 'Asia/Seoul';


--+ holdcas off;
