--test to_timestamp_tz function, with en_US language


set system parameters 'intl_date_lang=en_US';

--test: new tokens
select if(to_timestamp_tz('Africa/Addis_Ababa', 'TZR')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'Africa/Addis_Ababa'),'ok','nok');
select to_timestamp_tz('+5:00', 'TZR');
select to_timestamp_tz('Africa/Accra Ghana', 'TZR TZD');
select to_timestamp_tz('GMT', 'TZD');
select to_timestamp_tz('abc', 'TZR');
select to_timestamp_tz('aaa bbb', 'TZR TZD');
select to_timestamp_tz('Asia/Seoul CST', 'TZR TZD');

select if(to_timestamp_tz('10', 'TZH')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+10:00'),'ok','nok');
select if(to_timestamp_tz('23', 'TZM')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+00:23'),'ok','nok');
select if(to_timestamp_tz('+12', 'TZH')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+12:00'),'ok','nok');
select if(to_timestamp_tz('-5', 'TZH')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'-5:00'),'ok','nok');
select if(to_timestamp_tz('34', 'TZM')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+00:34'),'ok','nok');
select to_timestamp_tz('+60', 'TZM');
select to_timestamp_tz('-55', 'TZM');
select to_timestamp_tz('55.6', 'TZM');
select if(to_timestamp_tz('3:55', 'TZH:TZM')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+03:55'),'ok','nok');
select if(to_timestamp_tz('3:55', 'TZH:TZM')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'+03:55'),'ok','nok');
select if(to_timestamp_tz('-11:34', 'TZH:TZM')=from_tz(subdate( addtime( CURRENT_DATE , time '12:00:00 am'),  day( CURRENT_DATE )-1),'-11:34'),'ok','nok');

--[er] unsupported format
select to_timestamp_tz('10:10:45 Asia/Seoul 9', 'HH:MI:SS TZR TZH');
select to_timestamp_tz('10:10:45 Australia/Lindeman 00', 'HH:MI:SS TZR TZM');
select to_timestamp_tz('10:10:45 CST 8', 'HH:MI:SS TZD TZH');
select to_timestamp_tz('10:10:45 America/Tijuana PST -8', 'HH:MI:SS TZR TZD5 TZH');
select to_timestamp_tz('10:10:45 America/Cayman EST -5:00', 'HH:MI:SS TZR TZD TZH:TZM');


--test: time
select to_timestamp_tz('20 10 45 +10/00', 'SS HH MI +TZH/TZM');
select to_timestamp_tz('20 10 45 +-10/33', 'SS HH MI +TZH/TZM');
select if(to_timestamp_tz('05 55 58 am America/Manaus', 'HH MI SS AM TZR')=from_tz(subdate( addtime( CURRENT_DATE , time '05:55:58 am'),  day( CURRENT_DATE )-1),'America/Manaus'),'ok','nok');
select if(to_timestamp_tz('05 55 58 PM America/Manaus -04', 'HH MI SS AM TZR TZD')=from_tz(subdate( addtime( CURRENT_DATE , time '05:55:58 pm'),  day( CURRENT_DATE )-1),'America/Manaus -04'),'ok','nok');
select to_timestamp_tz('05 55 58 PM America/Manaus, AMST', 'HH MI SS AM TZR,TZD');
select to_timestamp_tz('EST 12:34:22 [PM] America/New_York', 'TZD HH:MI:SS [AM] TZR');
select to_timestamp_tz('EDT-12:34:22 (pm) America/New_York', 'TZD-HH:MI:SS (AM) TZR');


--test: datetime
select to_timestamp_tz('1999 Tuesday -10', 'YYYY DAY TZH');
select to_timestamp_tz('23-10-4 11:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM');
select to_timestamp_tz('December 3, 1971 11:33:10 PM 33', 'MONTH DD, YYYY HH:MI:SS PM TZM');
select to_timestamp_tz('12 January, 2037 11:33:10 am Asia/Shanghai', 'DD MONTH, YYYY HH:MI:SS AM TZR');
select to_timestamp_tz('2000-April-2 3:00:03 pm Asia/Baku-+05', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_timestamp_tz('11 30 59 pm Feb/27/2000 America/Fortaleza', 'HH MI SS AM MON/DD/YYYY TZR');
select to_timestamp_tz('11 30 59 pm Feb/27/2000 America/Fortaleza -03', 'HH MI SS AM MON/DD/YYYY TZR TZD');
select to_timestamp_tz('1991-April-2 3:00:03 pm Asia/Baku-+04', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
--test: [er] unmatched TZR and TZD 
select to_timestamp_tz('2000-April-2 3:00:03 pm Asia/Baku-AZT', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_timestamp_tz('2000-April-2 3:00:03 pm Asia/Baku-+05 4:00', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD TZH:TZM');
select to_timestamp_tz('2000-April-2 3:00:03 pm Asia/Baku-+04', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_timestamp_tz('11 30 59 pm Feb/27/2000 America/Fortaleza -02', 'HH MI SS AM MON/DD/YYYY TZR TZD');


--test: special time
--DST: non-exist time
select to_timestamp_tz('8 March, 2020 2 am America/Chicago', 'DD MONTH, YYYY HH AM TZR');
select to_timestamp_tz('1940, Apr. 28 2:30 America/New_York EST', 'YYYY, MON. DD HH24:MI TZR TZD');
select to_timestamp_tz('1940, Apr. 28 2:30 America/New_York EDT', 'YYYY, MON. DD HH24:MI TZR TZD');
select to_timestamp_tz('1920, Mar. 28 2:00 America/New_York', 'YYYY, MON. DD HH24:SS TZR');
set timezone 'Europe/Bucharest';
select to_timestamp_tz('12 01 01 am 1993/Mar/28', 'HH MI SS AM YYYY/MON/DD');
--DST: ambiguous time
select to_timestamp_tz('23:00/00 1993. Jan. 24 Pacific/Efate', 'HH24:MI/SS YYYY. MON. DD TZR');
select to_timestamp_tz('11:00/01 PM 1993. Jan. 24 Pacific/Efate +11', 'HH:MI/SS AM YYYY. MON. DD TZR TZD');
select to_timestamp_tz('11:59/59 PM 1993. Jan. 24 Pacific/Efate-VUST', 'HH:MI/SS AM YYYY. MON. DD TZR-TZD');
select to_timestamp_tz('11 30 59 pm Feb/26/2000 America/Fortaleza', 'HH MI SS AM MON/DD/YYYY TZR');
select to_timestamp_tz('11 30 59 pm Feb/26/2000 America/Fortaleza -03', 'HH MI SS AM MON/DD/YYYY TZR TZD');
select to_timestamp_tz('11 30 59 pm Feb/26/2000 America/Fortaleza -02', 'HH MI SS AM MON/DD/YYYY TZR TZD');


--test: all transitions of 'Europe/Uzhgorod'
select to_timestamp_tz('1879-Dec-31 11:59:59 PM Europe/Uzhgorod LMT', 'YYYY-MON-DD HH:MI:SS PM TZR TZD');
select to_timestamp_tz('1890-September-30 11:59:59 PM Europe/Uzhgorod LMT', 'YYYY-MONTH-DD HH:MI:SS PM TZR TZD');
select to_timestamp_tz('1890-September-30 11:59:59 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1890-September-30 11:30:48 PM Europe/Uzhgorod LMT', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1890-September-30 11:30:48 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1890-September-30 11:30:47 PM Europe/Uzhgorod LMT', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
--[er] non-exist
select to_timestamp_tz('1890-September-30 11:30:47 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1890-Oct-1 12:00:00 am Europe/Uzhgorod CET', 'YYYY-MON-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1939-December-31 23:59:59 Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH24:MI:SS TZR TZD');
select to_timestamp_tz('1940-January-1 12:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
--[er] non-exist
select to_timestamp_tz('1940-April-1 2:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');

select to_timestamp_tz('1940-April-1 2:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1940-April-1 3:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1941-November-20 2:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1944-October-1 12:00:00 AM Europe/Uzhgorod CEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1944-October-26 12:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1945-June-28 11:59:59 PM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
--[er] non-exist
select to_timestamp_tz('1945-June-29 12:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR');

select to_timestamp_tz('1945-June-29 1:59:59 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR');
select to_timestamp_tz('1945-June-29 2:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1968-August-3 2:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1982-April-1 1:00:00 AM Europe/Uzhgorod MSD', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1989-12-31 11:59:59 PM Europe/Uzhgorod MSK', 'YYYY-MM-DD HH:MI:SS PM TZR TZD');
select to_timestamp_tz('1990-January-1 12:00:00 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1990-July-1 1:59:59 AM Europe/Uzhgorod MSK', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1990-July-1 2:00:00 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1991-March-31 2:59:59 AM Europe/Uzhgorod CET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
--[er] non-exist
select to_timestamp_tz('1991-March-31 3:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR');
select to_timestamp_tz('1991-March-31 3:40:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');

select to_timestamp_tz('1991-March-31 4:00:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1991-December-31 11:59:59 PM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1992-January-1 12:00:00 AM Europe/Uzhgorod EET', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
select to_timestamp_tz('1993-March-28 1:00:00 AM Europe/Uzhgorod EEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');
--[er] non-exist
select to_timestamp_tz('1995-March-28 3:00:00 AM Europe/Uzhgorod', 'YYYY-MONTH-DD HH:MI:SS AM TZR');

select to_timestamp_tz('1995-March-28 4:00:00 AM Europe/Uzhgorod EEST', 'YYYY-MONTH-DD HH:MI:SS AM TZR TZD');



set timezone 'Asia/Seoul';

