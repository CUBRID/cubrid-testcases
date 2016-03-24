--test to_datetime function, with en_US language


set system parameters 'intl_date_lang=en_US';

--test: new tokens
--test: time
select to_datetime('20 10 45 +10/00', 'SS HH MI +TZH/TZM');
select to_datetime('20 10 45 +-10/33', 'SS HH MI +TZH/TZM');
select to_datetime('05 55 58 am America/Manaus', 'HH24 MI SS AM TZR');
select to_datetime('05 55 58 PM America/Manaus AMT', 'HH24 MI SS AM TZR TZD');
select to_datetime('05 55 58 PM America/Manaus AMST', 'HH24 MI SS AM TZR,TZD');


--test: datetime
select to_datetime('23-10-4 23:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM');
select to_datetime('12 January, 2099 11:33:10 am Asia/Shanghai', 'DD MONTH, YYYY HH:MI:SS AM TZR');
select to_datetime('2000-April-2 3:00:03 pm Asia/Baku-AZST 4:00', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD TZH:TZM');


--test: special time
--DST: non-exist time
select to_datetime('8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR');
--DST: ambiguous time
select to_datetime('11 30 59 pm Feb/26/2000 America/Fortaleza BRST', 'HH24 MI SS AM MON/DD/YYYY TZR TZD');



set timezone 'Asia/Seoul';

