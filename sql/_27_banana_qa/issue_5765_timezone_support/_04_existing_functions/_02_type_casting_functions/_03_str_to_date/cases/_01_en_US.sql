--test str_to_date function, with en_US language


set system parameters 'intl_date_lang=en_US';

--test: new tokens
select str_to_date('Africa/Addis_Ababa', '%TZR');
select str_to_date('+5:00', '%TZR');
select str_to_date('Africa/Accra Ghana', '%TZR %TZD');
select str_to_date('GMT', '%TZD');
select str_to_date('abc', '%TZR');
select str_to_date('aaa bbb', '%TZR %TZD');
select str_to_date('Asia/Seoul CST', '%TZR %TZD');

select str_to_date('10', '%TZH');
select str_to_date('23', '%TZM');
select str_to_date('+12', '%TZH');
select str_to_date('-5', '%TZH');
select str_to_date('34', '%TZM');
select str_to_date('+60', '%TZM');
select str_to_date('-55', '%TZM');
select str_to_date('55.6', '%TZM');
select str_to_date('3:55', '%TZH:%TZM');
select str_to_date('3:55', '%TZH:%TZM');
select str_to_date('-11:34', '%TZH:%TZM');

--[er] unsupported format
select str_to_date('10:10:45 Asia/Seoul 9', '%h:%i:%s %TZR %TZH');
select str_to_date('10:10:45 Australia/Lindeman 00', '%h:%i:%s %TZR %TZM');
select str_to_date('10:10:45 CST 8', '%h:%i:%s %TZD %TZH');
select str_to_date('10:10:45 America/Tijuana PST -8', '%h:%i:%s %TZR %TZD5 %TZH');
select str_to_date('10:10:45 America/Cayman EST -5:00', '%h:%i:%s %TZR %TZD %TZH:%TZM');


--test: time
select str_to_date('20 10 45 +10/00', '%S %h %i +%TZH/%TZM');
select str_to_date('20 10 45 +-10/33', '%S %h %i +%TZH/%TZM');
--BUG: CUBRIDSUS-17061, resolved
select str_to_date('05 55 58 am America/Manaus', '%h %i %S %p %TZR');
select str_to_date('05 55 58 PM America/Manaus AMT', '%h %i %S %p %TZR %TZD');
select str_to_date('05 55 58 PM America/Manaus AMST', '%h %i %S %p %TZR,%TZD');
select str_to_date('CST 12:34:22 [PM] America/Regina', '%TZD4 %h:%i:%s [%p] %TZR');
select str_to_date('MDT-12:34:22 (pm) America/Regina', '%TZD-%h:%i:%s (%p) %TZR');


--test: datetime
select str_to_date('1999 Tuesday -10', '%Y %W %TZH');
select str_to_date('23-10-4th 11:33:10 PM +4:30', '%y-%c-%D %r %TZH:%TZM');
select str_to_date('December 3rd, 1931 11:33:10 PM 33', '%M %D, %Y %r %TZM');
select str_to_date('12th January, 2099 11:33:10 am Asia/Shanghai', '%D %M, %Y %h:%i:%s %p %TZR');
select str_to_date('2000-April-2nd 3:00:03 pm Asia/Baku-+05', '%Y-%M-%D %r %TZR-%TZD');
select str_to_date('11 30 59 pm Feb/27th/2000 America/Fortaleza', '%h %i %S %p %b/%D/%Y %TZR');
select str_to_date('11 30 59 pm Feb/27th/2000 America/Fortaleza -03', '%h %i %S %p %b/%D/%Y %TZR %TZD');
--test: [er] unmatched TZR and TZD 
select str_to_date('2000-April-2nd 3:00:03 pm Asia/Baku-AZT', '%Y-%M-%D %r %TZR-%TZD');
select str_to_date('2000-April-2nd 3:00:03 pm Asia/Baku-AZST 4:00', '%Y-%M-%D %r %TZR-%TZD %TZH:%TZM');
select str_to_date('2000-April-2nd 3:00:03 pm Asia/Baku-BAKST', '%Y-%M-%D %r %TZR-%TZD');
select str_to_date('1991-April-2nd 3:00:03 pm Asia/Baku-BAKST', '%Y-%M-%D %r %TZR-%TZD');
--CBRD-21129
select str_to_date('11 30 59 pm Feb/27th/2000 America/Fortaleza -02', '%h %i %S %p %b/%D/%Y %TZR %TZD');


--test: special time
--DST: non-exist time
select str_to_date('8th March, 2020 2 am America/Chicago', '%D %M, %Y %h %p %TZR');
select str_to_date('1940, Apr. 28 2:30 America/New_York EST', '%Y, %b. %d %H:%i %TZR %TZD');
select str_to_date('1940, Apr. 28 2:30 America/New_York EDT', '%Y, %b. %d %H:%i %TZR %TZD');
select str_to_date('1920, Mar. 28 2:00 America/New_York', '%Y, %b. %d %H:%s %TZR');
set timezone 'Europe/Bucharest';
select str_to_date('12 01 01 am 1993/Mar/28th', '%h %i %s %p %Y/%b/%D');
--DST: ambiguous time
--BUG: CUBRIDSUS-16862, resolved
select if(str_to_date('23:00/00 1993. Jan. 23th Pacific/Efate', '%H:%i/%s %Y. %b. %D %TZR')=timestamptz'1993-01-23 23:00:00 Pacific/Efate +12', 'ok', 'nok');
select str_to_date('11:00/01 PM 1993. Jan. 23th Pacific/Efate +11', '%h:%i/%s %p %Y. %b. %D %TZR %TZD');
select str_to_date('11:59/59 PM 1993. Jan. 23th Pacific/Efate-+12', '%h:%i/%s %p %Y. %b. %D %TZR-%TZD');
--BUG: CUBRIDSUS-16862, resolved
select if(str_to_date('11 30 59 pm Feb/26th/2000 America/Fortaleza', '%h %i %S %p %b/%D/%Y %TZR')=timestamptz'2000-02-26 23:30:59 America/Fortaleza -02', 'ok', 'nok');
select str_to_date('11 30 59 pm Feb/26th/2000 America/Fortaleza -03', '%h %i %S %p %b/%D/%Y %TZR %TZD');
select str_to_date('11 30 59 pm Feb/26th/2000 America/Fortaleza -02', '%h %i %S %p %b/%D/%Y %TZR %TZD');
select if(str_to_date('1 40 00 am April/6th/2008 Australia/Lord_Howe +11', '%h %i %S %p %M/%D/%Y %TZR %TZD')=timestamptz'01:40:00 AM 04/06/2008 Australia/Lord_Howe', 'ok', 'nok');
select str_to_date('1 40 00 am Apr/6th/2008 Australia/Lord_Howe', '%h %i %S %p %b/%D/%Y %TZR %TZD')+1800;
--BUG: CUBRIDSUS-16399
select if(to_char(timestamptz'01:40:00 AM 04/06/2008 Australia/Lord_Howe', 'TZD')='+11', 'ok', 'nok');
select if(to_char(timestamptz'01:40:00 AM 04/06/2008 Australia/Lord_Howe'+1800, 'TZD')='+1030', 'ok', 'nok');


--test: all transitions of 'Europe/Uzhgorod'
select str_to_date('1879-Dec-31st 11:59:59 PM Europe/Uzhgorod LMT', '%Y-%b-%D %r %TZR %TZD');
select str_to_date('1890-September-30th 11:59:59 PM Europe/Uzhgorod LMT', '%Y-%M-%D %r %TZR %TZD');
--BUG: CUBRIDSUS-17063, resolved
select str_to_date('1890-September-30th 11:59:59 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1890-September-30th 11:30:48 PM Europe/Uzhgorod LMT', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--BUG: CUBRIDSUS-17148
select str_to_date('1890-September-30th 11:30:48 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1890-September-30th 11:30:47 PM Europe/Uzhgorod LMT', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--[er] non-existent
select str_to_date('1890-September-30th 11:30:47 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1890-Oct-1st 12:00:00 am Europe/Uzhgorod CET', '%Y-%b-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1939-December-31st 23:59:59 Europe/Uzhgorod CET', '%Y-%M-%D %H:%i:%s %TZR %TZD');
select str_to_date('1940-January-1st 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--[er] non-existent
select str_to_date('1940-April-1st 2:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1940-April-1st 2:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');

select str_to_date('1940-April-1st 3:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1941-November-20th 2:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1944-October-1st 12:00:00 AM Europe/Uzhgorod CEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1944-October-26th 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1945-June-28th 11:59:59 PM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--[er] non-exist
--BUG: CUBRIDSUS-17064, resolved
select str_to_date('1945-June-29th 12:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR');
select str_to_date('1945-June-29th 1:59:59 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR');

select str_to_date('1945-June-29th 2:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1968-August-3rd 2:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1982-April-1st 1:00:00 AM Europe/Uzhgorod MSD', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1989-12-31 11:59:59 PM Europe/Uzhgorod MSK', '%Y-%m-%d %r %TZR %TZD');
select str_to_date('1990-January-1st 12:00:00 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--BUG: CUBRIDSUS-17135
select str_to_date('1990-July-1st 1:59:59 AM Europe/Uzhgorod MSK', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1990-July-1st 12:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1990-July-1st 1:59:59 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1990-July-1st 2:00:00 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1991-March-31st 2:59:59 AM Europe/Uzhgorod CET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--[er] non-exist
select str_to_date('1991-March-31st 3:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR');
select str_to_date('1991-March-31st 3:40:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');

select str_to_date('1991-March-31st 4:00:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1991-December-31st 11:59:59 PM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1992-January-1st 12:00:00 AM Europe/Uzhgorod EET', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
select str_to_date('1993-March-28th 1:00:00 AM Europe/Uzhgorod EEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');
--[er] non-exist
select str_to_date('1995-March-26th 3:00:00 AM Europe/Uzhgorod', '%Y-%M-%D %h:%i:%s %p %TZR');

select str_to_date('1995-March-26th 4:00:00 AM Europe/Uzhgorod EEST', '%Y-%M-%D %h:%i:%s %p %TZR %TZD');



set timezone 'Asia/Seoul';

