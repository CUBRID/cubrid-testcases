--test to_time_tz function, with en_US language


set system parameters 'intl_date_lang=en_US';

--test: new tokens
select to_time_tz('Africa/Addis_Ababa', 'TZR');
select to_time_tz('+5:00', 'TZR');
select to_time_tz('Africa/Accra Ghana', 'TZR TZD');
select to_time_tz('GMT', 'TZD');
select to_time_tz('abc', 'TZR');
select to_time_tz('aaa bbb', 'TZR TZD');
select to_time_tz('Asia/Seoul CST', 'TZR TZD');

select to_time_tz('10', 'TZH');
select to_time_tz('23', 'TZM');
select to_time_tz('+12', 'TZH');
select to_time_tz('-5', 'TZH');
select to_time_tz('34', 'TZM');
select to_time_tz('+60', 'TZM');
select to_time_tz('-55', 'TZM');
select to_time_tz('55.6', 'TZM');
select to_time_tz('3:55', 'TZH:TZM');
select to_time_tz('3:55', 'TZH:TZM');
select to_time_tz('-11:34', 'TZH:TZM');

--[er] unsupported format
select to_time_tz('10:10:45 Asia/Seoul 9', 'HH:MI:SS TZR TZH');
select to_time_tz('10:10:45 Australia/Lindeman 00', 'HH:MI:SS TZR TZM');
select to_time_tz('10:10:45 CST 8', 'HH:MI:SS TZD TZH');
select to_time_tz('10:10:45 America/Tijuana PST -8', 'HH:MI:SS TZR TZD5 TZH');
select to_time_tz('10:10:45 America/Cayman EST -5:00', 'HH:MI:SS TZR TZD TZH:TZM');


--test: time
select to_time_tz('20 10 45 +10/00', 'SS HH MI +TZH/TZM');
select to_time_tz('20 10 45 +-10/33', 'SS HH MI +TZH/TZM');
select to_time_tz('20 10 45 +10/00', 'SS HH MI TZH/TZM');
select to_time_tz('20 10 45 -10/33', 'SS HH MI TZH/TZM');
select to_time_tz('05 55 58 America/Manaus', 'HH24 MI SS TZR');
select to_time_tz('05 55 58 PM America/Manaus AMT', 'HH MI SS AM TZR TZD');
select to_time_tz('05 55 58 PM America/Manaus AMST', 'HH MI SS AM TZR,TZD');
select to_time_tz('EAT 12:34:22 PM; Africa/Djibouti', 'TZD HH:MI:SS AM; TZR');
select to_time_tz('CXT-12:34:22 :pm/ Indian/Christmas', 'TZD-HH:MI:SS :AM/ TZR');


--test: datetime
select to_time_tz('1999 Tuesday -10', 'YYYY DD TZH');
select to_time_tz('23-10-4 23:33:10 PM +4:30', 'YY-MM-DD HH:MI:SS PM TZH:TZM');
select to_time_tz('December 3, 1931 23:33:10 PM 33', 'MONTH DD, YYYY HH:MI:SS PM TZM');
select to_time_tz('12 January, 2099 11:33:10 am Asia/Shanghai', 'DD MONTH, YYYY HH:MI:SS AM TZR');
select to_time_tz('2000-April-2 3:00:03 pm Asia/Baku-AZST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_time_tz('11 30 59 pm Feb/27/2000 America/Fortaleza', 'HH24 MI SS AM MON/DD/YYYY TZR');
select to_time_tz('11 30 59 pm Feb/27/2000 America/Fortaleza BRT', 'HH24 MI SS AM MON/DD/YYYY TZR TZD');
--test: [er] unmatched TZR and TZD 
select to_time_tz('2000-April-2 3:00:03 pm Asia/Baku-AZT', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_time_tz('2000-April-2 3:00:03 pm Asia/Baku-AZST 4:00', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD TZH:TZM');
select to_time_tz('2000-April-2 3:00:03 pm Asia/Baku-BAKST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_time_tz('1991-April-2 3:00:03 pm Asia/Baku-BAKST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_time_tz('11 30 59 pm Feb/27/2000 America/Fortaleza BRST', 'HH24 MI SS AM MON/DD/YYYY TZR TZD');


set timezone 'Asia/Seoul';

