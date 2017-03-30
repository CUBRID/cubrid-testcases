--test to_timestamp_tz function, with en_US language
--+ holdcas on;


set system parameters 'intl_date_lang=en_US';

prepare st from 'select to_char(to_timestamp_tz(?, ?),?)';

--test: new tokens
execute st using 'Africa/Addis_Ababa', 'TZR','DD,HH24:MI:SS TZR TZD';
execute st using '+5:00', 'TZR','DD, HH24:MI:SS TZR TZD';
execute st using 'Africa/Accra Ghana', 'TZR TZD','DD,HH24:MI:SS TZR TZD';
execute st using 'GMT', 'TZD','DD, HH24:MI:SS TZR TZD';
execute st using 'abc', 'TZR','DD, HH24:MI:SS TZR TZD';
execute st using 'aaa bbb', 'TZR TZD','DD, HH24:MI:SS TZR TZD';
execute st using 'Asia/Seoul CST', 'TZR TZD','DD,HH24:MI:SS TZR TZD';

execute st using '10', 'TZH','DD, HH24:MI:SS TZR TZD';
execute st using '23', 'TZM','DD, HH24:MI:SS TZR TZD';
execute st using '+12', 'TZH','DD,HH24:MI:SS TZR TZD';
execute st using '-5', 'TZH','DD,HH24:MI:SS TZR TZD';
execute st using '34', 'TZM','DD,HH24:MI:SS TZR TZD';
execute st using '+60', 'TZM','DD,HH24:MI:SS TZR TZD';
execute st using '-55', 'TZM','DD,HH24:MI:SS TZR TZD';
execute st using '55.6', 'TZM','DD,HH24:MI:SS TZR TZD';
execute st using '3:55', 'TZH:TZM','DD,HH24:MI:SS TZR TZD';
execute st using '3:55', 'TZH:TZM','DD,HH24:MI:SS TZR TZD';
execute st using '-11:34', 'TZH:TZM','DD,HH24:MI:SS TZR TZD';

--[er] unsupported format
prepare st from 'select to_timestamp_tz(?, ?)';
execute st using '10:10:45 Asia/Seoul 9', 'HH:MI:SS TZR TZH';
execute st using '10:10:45 Auralia/Lieman 00', 'HH:MI:SS TZR TZM';
execute st using '10:10:45 CST 8', 'HH:MI:SS TZD TZH';
execute st using '10:10:45 America/Tijuana PST -8', 'HH:MI:SS TZR TZD5 TZH';
execute st using '10:10:45 America/Cayman EST -5:00', 'HH:MI:SS TZR TZD TZH:TZM';


prepare st from 'select to_timestamp_tz(?, ?, ''en_US'')';
--test: time
execute st using '20 10 45 +10/00', 'SS HH MI +TZH/TZM';
execute st using '20 10 45 +-10/33', 'SS HH MI +TZH/TZM';
prepare st from 'select to_char(to_timestamp_tz(?, ?),?)';
execute st using '05 55 58 am America/Manaus', 'HH MI SS AM TZR','DD,HH24:MI:SS TZR TZD';
execute st using '05 55 58 PM America/Manaus -04', 'HH MI SS AM TZR TZD','DD,HH24:MI:SS TZR TZD';
prepare st from 'select to_timestamp_tz(?, ?)';
execute st using '05 55 58 PM America/Manaus AMST', 'HH MI SS AM TZR,TZD';
execute st using 'EST 12:34:22 [PM] America/New_York', 'TZD HH:MI:SS [AM] TZR';
execute st using 'EDT-12:34:22 (pm) America/New_York', 'TZD-HH:MI:SS (AM) TZR';


--test: datetime
execute st using '1999 Tuesday -10', 'YYYY DD TZH';
execute st using '23-10-4 23:33:10 +4:30', 'YY-MM-DD HH24:MI:SS TZH:TZM';
execute st using 'December 3, 1931 11:33:10 PM 33', 'MONTH DD, YYYY HH:MI:SS PM TZM';
execute st using '12 January, 2099 11:33:10 am Asia/Shanghai', 'DD MONTH, YYYY HH:MI:SS AM TZR';
execute st using '2000-April-2 3:00:03 pm Asia/Baku-+05', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';
execute st using '11 30 59 pm Feb/27/2000 America/Fortaleza', 'HH MI SS AM MON/DD/YYYY TZR';
execute st using '11 30 59 pm Feb/27/2000 America/Fortaleza -03', 'HH MI SS AM MON/DD/YYYY TZR TZD';
--test: [er] unmatched TZR a TZD 
execute st using '2000-April-2 3:00:03 pm Asia/Baku-AZT', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';
execute st using '2000-April-2 3:00:03 pm Asia/Baku-+05 4:00', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD TZH:TZM';
execute st using '2000-April-2 3:00:03 pm Asia/Baku-+04', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';
execute st using '1991-April-2 3:00:03 pm Asia/Baku-+04', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';
execute st using '11 30 59 pm Feb/27/2000 America/Fortaleza -02', 'HH MI SS AM MON/DD/YYYY TZR TZD';


--test: special time
--DST: non-exist time
execute st using '8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR';
execute st using '1940, Apr. 28 2:30 America/New_York EST', 'YYYY, MON. DD HH24:MI TZR TZD';
execute st using '1940, Apr. 28 2:30 America/New_York EDT', 'YYYY, MON. DD HH24:MI TZR TZD';
execute st using '1920, Mar. 28 2:00 America/New_York', 'YYYY, MON. DD HH24:SS TZR';
set timezone 'Europe/Buchare';
execute st using '12 01 01 am 1993/Mar/28', 'HH MI SS AM YYYY/MON/DD';
--DST: ambiguous time
execute st using '23:00/00 1993. Jan. 24 Pacific/Efate', 'HH24:MI/SS YYYY. MON. DD TZR';
execute st using '11:00/01 PM 1993. Jan. 24 Pacific/Efate +11', 'HH:MI/SS AM YYYY. MON. DD TZR TZD';
execute st using '11:59/59 PM 1993. Jan. 24 Pacific/Efate-VUST', 'HH:MI/SS AM YYYY. MON. DD TZR-TZD';
execute st using '11 30 59 pm Feb/26/2000 America/Fortaleza', 'HH MI SS AM MON/DD/YYYY TZR';
execute st using '11 30 59 pm Feb/26/2000 America/Fortaleza -03', 'HH MI SS AM MON/DD/YYYY TZR TZD';
execute st using '11 30 59 pm Feb/26/2000 America/Fortaleza -02', 'HH MI SS AM MON/DD/YYYY TZR TZD';


--test: all transitions of 'Europe/Uzhgorod'
execute st using '1879-Dec-31 11:59:59 PM Europe/Uzhgorod LMT', 'YYYY-MON-DD HH:MI:SS PM TZR TZD';
execute st using '1890-September-30 11:59:59 PM Europe/Uzhgorod LMT', 'YYYY-MONTH-DD HH:MI:SS PM TZR TZD';
execute st using '1890-September-30 11:59:59 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1890-Oct-1 12:00:00 am Europe/Uzhgorod CET', 'YYYY-MON-DD HH:MI:SS AM TZR TZD';
execute st using '1939-December-31 23:59:59 Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH24:MI:SS TZR TZD';
execute st using '1940-January-1 12:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
--[er] non-exist
execute st using '1940-April-1 2:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';

execute st using '1940-April-1 2:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1940-April-1 3:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1941-November-20 2:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1944-October-1 12:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1944-October-26 12:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1945-June-28 11:59:59 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
--[er] non-exist
execute st using '1945-June-29 12:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR';

execute st using '1945-June-29 1:59:59 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR';
execute st using '1945-June-29 2:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1968-Augu-3 2:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1982-April-1 1:00:00 AM Europe/Uzhgorod MSD', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1989-12-31 11:59:59 PM Europe/Uzhgorod MSK', 'YYYY-MM-DD HH:MI:SS PM TZR TZD';
execute st using '1990-January-1 12:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1990-July-1 1:59:59 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1990-July-1 2:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1991-March-31 2:59:59 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
--[er] non-exist
execute st using '1991-March-31 3:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR';
execute st using '1991-March-31 3:40:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';

execute st using '1991-March-31 4:00:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1991-December-31 11:59:59 PM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1992-January-1 12:00:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
execute st using '1993-March-28 1:00:00 AM Europe/Uzhgorod EEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';
--[er] non-exist
execute st using '1995-March-28 3:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR';

execute st using '1995-March-28 4:00:00 AM Europe/Uzhgorod EEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD';


deallocate prepare st;
set timezone 'Asia/Seoul';


--+ holdcas off;
