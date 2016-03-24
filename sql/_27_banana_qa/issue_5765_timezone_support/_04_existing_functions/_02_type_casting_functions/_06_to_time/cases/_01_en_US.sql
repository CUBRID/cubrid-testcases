--test to_time function, with en_US language


set system parameters 'intl_date_lang=en_US';

--test: new tokens
select to_time('Africa/Addis_Ababa', 'TZR');
select to_time('GMT', 'TZD');
select to_time('Asia/Seoul CST', 'TZR TZD');

select to_time('10', 'TZH');
select to_time('23', 'TZM');
select to_time('-11:34', 'TZH:TZM');

select to_time('10:10:45 America/Cayman EST -5:00', 'HH:MI:SS TZR TZD TZH:TZM');


--test: time
select to_time('20 10 45 +10/00', 'SS HH MI +TZH/TZM');

--test: datetime
select to_time('1999 Tuesday -10', 'YYYY DD TZH');
select to_time('23-10-4 23:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM');
select to_time('2000-April-2 3:00:03 pm Asia/Baku-AZST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_time('11 30 59 pm Feb/27/2000 America/Fortaleza BRT', 'HH24 MI SS AM MON/DD/YYYY TZR TZD');


--test: special time
--DST: non-exist time
select to_time('8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR');
--DST: ambiguous time
select to_time('23:00/00 1993. Jan. 24 Pacific/Efate', 'HH24:MI/SS YYYY. MON. DD TZR');


set timezone 'Asia/Seoul';

