--test str_to_date function, with en_US language
--+ holdcas on;


set system parameters 'intl_date_lang=en_US';

prepare st from 'select str_to_date(?, ?)';

--test: new tokens
execute st using 'Africa/Addis_Ababa', '%TZR';
execute st using '+5:00', '%TZR';
execute st using 'Africa/Accra Ghana', '%TZR %TZD';
execute st using 'GMT', '%TZD';
execute st using 'abc', '%TZR';
execute st using 'aaa bbb', '%TZR %TZD';
execute st using 'Asia/Seoul CST', '%TZR %TZD';

execute st using '10', '%TZH';
execute st using '23', '%TZM';
execute st using '+12', '%TZH';
execute st using '-5', '%TZH';
execute st using '34', '%TZM';
execute st using '+60', '%TZM';
execute st using '-55', '%TZM';
execute st using '55.6', '%TZM';
execute st using '3:55', '%TZH:%TZM';
execute st using '3:55', '%TZH:%TZM';
execute st using '-11:34', '%TZH:%TZM';

--[er] unsupported format
execute st using '10:10:45 Asia/Seoul 9', '%h:%i:%s %TZR %TZH';
execute st using '10:10:45 Australia/Lindeman 00', '%h:%i:%s %TZR %TZM';
execute st using '10:10:45 CST 8', '%h:%i:%s %TZD %TZH';
execute st using '10:10:45 America/Tijuana PST -8', '%h:%i:%s %TZR %TZD5 %TZH';
execute st using '10:10:45 America/Cayman EST -5:00', '%h:%i:%s %TZR %TZD %TZH:%TZM';


--test: time
execute st using '20 10 45 +10/00', '%S %h %i +%TZH/%TZM';
execute st using '20 10 45 +-10/33', '%S %h %i +%TZH/%TZM';
execute st using '05 55 58 am America/Manaus', '%h %i %S %p %TZR';
execute st using '05 55 58 PM America/Manaus AMT', '%h %i %S %p %TZR %TZD';
execute st using '05 55 58 PM America/Manaus AMST', '%h %i %S %p %TZR,%TZD';
execute st using 'CST 12:34:22 [PM] America/Regina', '%TZD %h:%i:%s [%p] %TZR';
execute st using 'CST-12:34:22 (pm) America/Regina', '%TZD-%h:%i:%s (%p) %TZR';


--test: datetime
execute st using '1999 Tuesday -10', '%Y %W %TZH';
execute st using '23-10-4th 11:33:10 PM +4:30', '%y-%c-%D %r %TZH:%TZM';
execute st using 'December 3rd, 1931 11:33:10 PM 33', '%M %D, %Y %r %TZM';
execute st using '12th January, 2099 11:33:10 am Asia/Shanghai', '%D %M, %Y %h:%i:%s %p %TZR';
execute st using '2000-April-2nd 3:00:03 pm Asia/Baku-+05', '%Y-%M-%D %r %TZR-%TZD';
execute st using '11 30 59 pm Feb/27th/2000 America/Fortaleza', '%h %i %S %p %b/%D/%Y %TZR';
execute st using '11 30 59 pm Feb/27th/2000 America/Fortaleza -03', '%h %i %S %p %b/%D/%Y %TZR %TZD';
--test: [er] unmatched TZR and TZD 
execute st using '2000-April-2nd 3:00:03 pm Asia/Baku-AZT', '%Y-%M-%D %r %TZR-%TZD';
execute st using '2000-April-2nd 3:00:03 pm Asia/Baku-AZST 4:00', '%Y-%M-%D %r %TZR-%TZD %TZH:%TZM';
execute st using '2000-April-2nd 3:00:03 pm Asia/Baku-BAKST', '%Y-%M-%D %r %TZR-%TZD';
execute st using '1991-April-2nd 3:00:03 pm Asia/Baku-BAKST', '%Y-%M-%D %r %TZR-%TZD';
execute st using '11 30 59 pm Feb/27th/2000 America/Fortaleza BRST', '%h %i %S %p %b/%D/%Y %TZR %TZD';


--test: special time
--DST: non-exist time
execute st using '8th March, 2020 2 am America/Chicago', '%D %M, %Y %h %p %TZR';
execute st using '1940, Apr. 28 2:30 America/New_York EST', '%Y, %b. %d %H:%i %TZR %TZD';
execute st using '1940, Apr. 28 2:30 America/New_York EDT', '%Y, %b. %d %H:%i %TZR %TZD';
execute st using '1920, Mar. 28 2:00 America/New_York', '%Y, %b. %d %H:%s %TZR';
set timezone 'Europe/Bucharest';
execute st using '12 01 01 am 1993/Mar/28th', '%h %i %s %p %Y/%b/%D';
--DST: ambiguous time
--BUG: CUBRIDSUS-16862, resolved
execute st using '23:00/00 1993. Jan. 23th Pacific/Efate', '%H:%i/%s %Y. %b. %D %TZR';
execute st using '11:00/01 PM 1993. Jan. 23th Pacific/Efate +11', '%h:%i/%s %p %Y. %b. %D %TZR %TZD';
execute st using '11:59/59 PM 1993. Jan. 23th Pacific/Efate-+12', '%h:%i/%s %p %Y. %b. %D %TZR-%TZD';
--BUG: CUBRIDSUS-16862, resolved
execute st using '11 30 59 pm Feb/26th/2000 America/Fortaleza', '%h %i %S %p %b/%D/%Y %TZR';
execute st using '11 30 59 pm Feb/26th/2000 America/Fortaleza -03', '%h %i %S %p %b/%D/%Y %TZR %TZD';
execute st using '11 30 59 pm Feb/26th/2000 America/Fortaleza -02', '%h %i %S %p %b/%D/%Y %TZR %TZD';


--test: all transitions of 'Europe/Uzhgorod'
execute st using '1879-Dec-31st 11:59:59 PM Europe/Uzhgorod LMT', '%Y-%b-%D %r %TZR %TZD';
execute st using '1890-September-30th 11:59:59 PM Europe/Uzhgorod LMT', '%Y-%M-%D %r %TZR %TZD';
execute st using '1890-September-30th 11:59:59 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1890-Oct-1st 12:00:00 am Europe/Uzhgorod CET', '%Y-%b-%D %h:%i:%s %p %TZR %TZD';
execute st using '1939-December-31st 23:59:59 Europe/Uzhgorod CET', '%Y-%M-%D %H:%i:%s %TZR %TZD';
execute st using '1940-January-1st 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
--[er] non-exist
execute st using '1940-April-1st 2:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';

execute st using '1940-April-1st 2:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1940-April-1st 3:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1941-November-20th 2:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1944-October-1st 12:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1944-October-26th 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1945-June-28th 11:59:59 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
--[er] non-exist
execute st using '1945-June-29th 12:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR';
execute st using '1945-June-29th 1:59:59 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR';

execute st using '1945-June-29th 2:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1968-August-3rd 2:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1982-April-1st 1:00:00 AM Europe/Uzhgorod MSD', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1989-12-31 11:59:59 PM Europe/Uzhgorod MSK', '%Y-%m-%d %r %TZR %TZD';
execute st using '1990-January-1st 12:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
--BUG: CUBRIDSUS-17135
execute st using '1990-July-1st 1:59:59 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1990-July-1st 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1990-July-1st 1:59:59 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1990-July-1st 2:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';

execute st using '1991-March-31st 2:59:59 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
--[er] non-exist
execute st using '1991-March-31st 3:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR';
execute st using '1991-March-31st 3:40:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';

execute st using '1991-March-31st 4:00:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1991-December-31st 11:59:59 PM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1992-January-1st 12:00:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
execute st using '1993-March-28th 1:00:00 AM Europe/Uzhgorod EEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';
--[er] non-exist
execute st using '1995-March-26th 3:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR';

execute st using '1995-March-26th 4:00:00 AM Europe/Uzhgorod EEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD';


deallocate prepare st;
set timezone 'Asia/Seoul';


--+ holdcas off;
