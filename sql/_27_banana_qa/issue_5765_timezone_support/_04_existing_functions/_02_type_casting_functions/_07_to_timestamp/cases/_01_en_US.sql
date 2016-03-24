--test to_timestamp function, with en_US language


set system parameters 'intl_date_lang=en_US';

select to_timestamp('3:55', 'TZH:TZM');
select to_timestamp('10:10:45 Asia/Seoul 9', 'HH:MI:SS TZR TZH');
select to_timestamp('10:10:45 CST 8', 'HH:MI:SS TZD TZH');


--test: time
select to_timestamp('20 10 45 +10/00', 'SS HH MI +TZH/TZM');
select to_timestamp('05 55 58 am America/Manaus', 'HH24 MI SS AM TZR');
select to_timestamp('05 55 58 PM America/Manaus AMT', 'HH24 MI SS AM TZR TZD');


--test: datetime
select to_timestamp('1999 Tuesday -10', 'YYYY DD TZH');
select to_timestamp('December 3, 1931 23:33:10 PM 33', 'MONTH DD, YYYY HH:MI:SS PM TZM');
select to_timestamp('2000-April-2 3:00:03 pm Asia/Baku-AZST', 'YYYY-MONTH-DD HH:MI:SS PM TZR-TZD');
select to_timestamp('12 01 01 am 1993/Mar/28', 'HH MI SS AM YYYY/MON/DD');
--DST: ambiguous time
select to_timestamp('23:00/00 1993. Jan. 24 Pacific/Efate', 'HH24:MI/SS YYYY. MON. DD TZR');
select to_timestamp('11 30 59 pm Feb/26/2000 America/Fortaleza BRT', 'HH24 MI SS AM MON/DD/YYYY TZR TZD');



set timezone 'Asia/Seoul';

