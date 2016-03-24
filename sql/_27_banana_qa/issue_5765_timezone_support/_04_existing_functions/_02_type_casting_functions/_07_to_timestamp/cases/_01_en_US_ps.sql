--test to_timestamp function, with en_US language
--+ holdcas on;


set system parameters 'intl_date_lang=en_US';

prepare st from 'select to_timestamp(?, ?)';

execute st using '10:10:45 CST 8', 'HH:MI:SS TZD TZH';
execute st using '10:10:45 America/Tijuana PST -8', 'HH:MI:SS TZR TZD5 TZH';


prepare st from 'select to_timestamp(?, ?, ''en_US'')';
--test: time
execute st using '20 10 45 +10/00', 'SS HH MI +TZH/TZM';
execute st using '05 55 58 am America/Manaus', 'HH24 MI SS AM TZR';
execute st using 'EDT-12:34:22 (pm) America/New_York', 'TZD-HH:MI:SS (AM) TZR';


--test: datetime
execute st using '1999 Tuesday -10', 'YYYY DD TZH';
execute st using 'December 3, 1931 23:33:10 PM 33', 'MONTH DD, YYYY HH:MI:SS PM TZM';
execute st using '2000-April-2 3:00:03 pm Asia/Baku-AZST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';
execute st using '11 30 59 pm Feb/27/2000 America/Fortaleza BRT', 'HH24 MI SS AM MON/DD/YYYY TZR TZD';
--test: [er] unmatched TZR a TZD 
execute st using '2000-April-2 3:00:03 pm Asia/Baku-AZST 4:00', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD TZH:TZM';


--test: special time
--DST: non-exist time
execute st using '8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR';
execute st using '1940, Apr. 28 2:30 America/New_York EST', 'YYYY, MON. DD HH24:MI TZR TZD';
execute st using '1940, Apr. 28 2:30 America/New_York EDT', 'YYYY, MON. DD HH24:MI TZR TZD';
execute st using '1920, Mar. 28 2:00 America/New_York', 'YYYY, MON. DD HH24:SS TZR';


deallocate prepare st;
set timezone 'Asia/Seoul';


--+ holdcas off;
