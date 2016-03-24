--test to_datetime function, with en_US language
--+ holdcas on;


set system parameters 'intl_date_lang=en_US';

prepare st from 'select to_datetime(?, ?)';

--test: new tokens
execute st using '3:55', 'TZH:TZM';
execute st using '10:10:45 America/Cayman EST -5:00', 'HH:MI:SS TZR TZD TZH:TZM';


prepare st from 'select to_datetime(?, ?, ''en_US'')';
--test: time
execute st using '20 10 45 +10/00', 'SS HH MI +TZH/TZM';
execute st using '05 55 58 am America/Manaus', 'HH24 MI SS AM TZR';
execute st using '05 55 58 PM America/Manaus AMST', 'HH24 MI SS AM TZR,TZD';


--test: datetime
execute st using '23-10-4 23:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM';
execute st using '12 January, 2099 11:33:10 am Asia/Shanghai', 'DD MONTH, YYYY HH:MI:SS AM TZR';
execute st using '11 30 59 pm Feb/27/2000 America/Fortaleza', 'HH24 MI SS AM MON/DD/YYYY TZR';
--test: [er] unmatched TZR a TZD 
execute st using '2000-April-2 3:00:03 pm Asia/Baku-AZT', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD';



deallocate prepare st;
set timezone 'Asia/Seoul';


--+ holdcas off;
