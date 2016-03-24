--test with 'Europe/Vienna' time zone

--+ holdcas on;

set timezone 'America/New_York';

prepare make_time from 'select if(from_tz(?, ''America/New_York'')=?, ''ok'', ''nok'')';
prepare trans from 'select if(?+?=?, ''ok'', ''nok'')';
prepare sub from 'select if(?-?=?, ''ok'', ''nok'')';
prepare equal from 'select if(?=?, ''ok'', ''nok'')';


execute equal using datetimetz'1791-12-10 00:00:00', datetimetz'1791-12-10 4:56:02 GMT';
--BUG: CUBRIDSUS-17173
execute make_time using datetime'1883-11-18 12:00:00', datetimetz'1883-11-18 12:00:00 America/New_York LMT';
execute trans using datetimetz'1883-11-18 12:03:57 America/New_York', 1000, datetimetz'1883-11-18 12:00:00 America/New_York EST';
execute equal using datetimetz'1883-11-18 12:03:58 America/New_York EST', datetimetz'1883-11-18 17:03:58 UTC';

--[er] non-existent
select datetimeltz'1918-03-31 2:00:00';
--ambiguous
execute make_time using datetime'1918-10-27 1:00:00', datetimetz'1918-10-27 1:00:00 America/New_York EDT';
execute trans using datetimetz'1918-10-27 1:00:00 America/New_York EDT', 3600000, datetimetz'1918-10-27 1:00:00 America/New_York EST';

execute trans using datetimeltz'1919-03-30 1:59:59', 1000, datetimeltz'1919-03-30 3:00:00';
execute trans using datetimetz'1919-10-26 1:30:00 America/New_York EDT', 3600000, datetimetz'1919-10-26 1:30:00 America/New_York EST';

execute equal using datetimeltz'1920-01-01 00:00:00', datetimetz'1920-01-01 5:00:00 UTC';
execute trans using datetimeltz'1920-03-28 1:59:59.999', 1, datetimetz'1920-03-28 3:00:00 America/New_York EDT';
execute sub using datetimetz'1920-10-31 1:00:00 America/New_York EST', 1, datetimetz'1920-10-31 1:59:59.999 America/New_York EDT';

--[er] non-existent
--BUG: CUBRIDSUS-17174
select datetimetz'1921-04-24 2:00:00';

execute trans using datetimetz'1922-04-30 1:59:59 America/New_York EST', 1000, datetimetz'1922-04-30 3:00:00 America/New_York EDT';
execute trans using datetimeltz'1921-09-25 1:59:59', 1000, datetimeltz'1921-09-25 1:00:00 America/New_York EST';
execute sub using datetimeltz'1935-04-28 3:00:00 America/New_York EDT', 1000, datetimetz'1935-04-28 1:59:59 America/New_York EST';
execute trans using datetimetz'1935-09-29 00:59:59.999', 3600001, datetimeltz'1935-09-29 1:00:00 America/New_York EST';
execute trans using datetimetz'1941-04-27 1:50:00 America/New_York EST', 3600000, datetimetz'1941-04-27 3:50:00 America/New_York EDT';
execute sub using datetimeltz'1941-09-28 2:00:00 America/New_York EST', 3600001, datetimeltz'1941-09-28 1:59:59.999 America/New_York EDT';

execute equal using datetimeltz'1942-01-01 00:00:00', datetimetz'1942-01-01 5:00:00 +00:00';

--War time
execute trans using datetimetz'1942-02-09 1:59:59', 1000, datetimetz'1942-02-09 3:00:00 America/New_York EWT';
execute make_time using datetime'1942-12-20 14:01:34', datetimetz'1942-12-20 14:01:34 America/New_York EWT';
execute make_time using datetime'1943-07-01 3:00:00', datetimetz'1943-07-01 3:00:00 America/New_York EWT';
--BUG: CUBRIDSUS-17138
execute equal using datetimeltz'1944-11-01 00:00:00 America/New_York EWT', datetimetz'1944-11-01 4:00:00 GMT';
execute equal using datetimetz'1945-07-01 20:00:00 America/New_York EWT', datetimetz'1945-07-02 00:00:00 UTC';
--Peace time
execute trans using datetimeltz'1945-08-14 18:00:00 America/New_York EWT', 3600000, datetimeltz'1945-08-14 19:00:00 America/New_York EPT';
execute trans using datetimeltz'1945-08-14 18:59:59 America/New_York EWT', 2000, datetimeltz'1945-08-14 19:00:01 America/New_York EPT';
execute equal using datetimeltz'1945-03-31 00:00:00 America/New_York EPT', datetimetz'1945-03-31 4:00:00 GMT';
execute make_time using datetime'1945-06-15 7:00:00', datetimetz'1945-06-15 7:00:00 America/New_York EPT';

execute trans using datetimetz'1945-09-30 1:59:59 America/New_York EPT', 1000, datetimetz'1945-09-30 1:00:00 America/New_York EST';
execute equal using datetimetz'1945-11-30 00:00:00 America/New_York EST', datetimetz'1945-11-30 5:00:00 UTC';
execute make_time using datetime'1946-01-01 00:00:00', datetimetz'1946-01-01 00:00:00 America/New_York EST';

--[er] non-existent
select datetimeltz'1946-04-28 2:00:00';

execute trans using datetimetz'1946-04-28 00:00:00', 7200000, '1946-04-28 3:00:00 America/New_York EDT';
execute sub using datetimeltz'1946-09-29 1:50:50 America/New_York EST', 3600000, datetimeltz'1946-09-29 1:50:50 America/New_York EDT';
execute sub using datetimetz'1954-04-25 4:00:00 America/New_York EDT', 7200000, datetimetz'1954-04-25 1:00:00 America/New_York EST';
execute trans using datetimeltz'1954-09-26 1:50:50 America/New_York EDT', 3600000, datetimeltz'1954-09-26 1:50:50 America/New_York EST';
--BUG: CUBRIDSUS-17174
execute trans using datetimeltz'1955-04-24 6:59:59.999 UTC', 1, datetimetz'1955-04-24 3:00:00 America/New_York EDT';
execute trans using datetimetz'1955-10-30 1:59:59 America/New_York EDT', 1000, datetimetz'1955-10-30 1:00:00 America/New_York EST';
--BUG: CUBRIDSUS-17680
execute sub using datetimetz'1960-04-24 3:00:00 America/New_York EDT', 1000, datetimetz'1960-04-24 1:59:59 America/New_York EST';
execute sub using datetimetz'1962-10-28 1:59:59 America/New_York EST', 3600000, datetimeltz'1962-10-28 1:59:59 America/New_York EDT';

--[er] non-existent
--BUG: CUBRIDSUS-17680
execute make_time using datetime'1966-04-24 2:00:00', datetimeltz'1966-04-24 3:00:00 America/New_York EDT';

execute trans using datetimeltz'1966-10-30 1:30:30 America/New_York EDT', 3600000, datetimetz'1966-10-30 1:30:30 America/New_York EST';
execute make_time using datetime'1967-01-01 00:00:00', datetimetz'1967-01-01 00:00:00 America/New_York EST';
execute trans using datetimetz'1967-04-30 1:59:59.999 America/New_York EST', 1, datetimetz'1967-04-30 3:00:00 America/New_York EDT';
execute trans using datetimetz'1967-10-29 1:59:59.999 America/New_York EDT', 1, datetimetz'1967-10-29 1:00:00 America/New_York EST';
execute make_time using datetime'1970-04-26 1:59:59', datetimetz'1970-04-26 1:59:59 America/New_York EST';
execute make_time using datetime'1970-04-26 3:00:00', datetimetz'1970-04-26 3:00:00 America/New_York EDT';
execute trans using datetimetz'1971-10-31 1:59:59 America/New_York EDT', 1000, datetimetz'1971-10-31 1:00:00 America/New_York EST';

--[er] non-existent
--BUG: CUBRIDSUS-17175
select datetimeltz'1973-04-29 2:30:30';

execute trans using timestamptz'1974-01-06 1:59:59 America/New_York EST', 1, timestamptz'1974-01-06 3:00:00 America/New_York EDT';
execute make_time using datetime'1974-03-01 5:00:00', datetimetz'1974-03-01 5:00:00 America/New_York EDT';
execute trans using timestamptz'1974-10-27 1:59:59 America/New_York EDT', 1, datetimetz'1974-10-27 1:00:00 America/New_York EST';
execute equal using timestamptz'1975-02-22 23:59:59 America/New_York EST', datetimetz'1975-02-23 4:59:59 UTC';
execute sub using timestamptz'1975-02-23 3:00:00 America/New_York EDT', 1, timestamptz'1975-02-23 1:59:59 America/New_York EST';
execute trans using timestampltz'1976-04-25 1:59:59 America/New_York EST', 3600, datetimetz'1976-04-25 3:59:59 America/New_York EDT';
execute sub using timestamptz'1976-10-31 1:00:00 America/New_York EST', 1, datetimetz'1976-10-31 1:59:59 America/New_York EDT';

--[er] non-existent
select datetimetz'1980-04-27 2:00:00 America/New_York';

execute trans using timestamptz'1982-10-31 1:30:59 America/New_York EDT', 3600, timestamptz'1982-10-31 1:30:59 America/New_York EST';
execute trans using timestampltz'1986-04-27 1:59:59 America/New_York EST', 1, datetimeltz'1986-04-27 3:00:00 America/New_York EDT';
execute trans using timestamptz'1986-10-26 1:59:59 America/New_York EDT', 1, datetimetz'1986-10-26 1:00:00 America/New_York EST';
execute trans using timestampltz'1987-04-05 1:59:59 America/New_York EST', 1, timestamptz'1987-04-05 3:00:00 America/New_York EDT';
execute trans using timestamptz'1988-10-30 1:59:59 America/New_York EDT', 1, datetimetz'1988-10-30 1:00:00 America/New_York EST';
execute trans using timestamptz'2003-04-06 1:59:59 America/New_York EST', 1, timestamptz'2003-04-06 3:00:00 America/New_York EDT';
execute trans using timestamptz'2003-10-26 1:59:59 America/New_York EDT', 1, datetimetz'2003-10-26 1:00:00 America/New_York EST';
execute trans using timestamptz'2006-04-02 1:59:59 America/New_York EST', 1, timestamptz'2006-04-02 3:00:00 America/New_York EDT';
execute trans using timestamptz'2006-10-29 1:59:59 America/New_York EDT', 1, datetimetz'2006-10-29 1:00:00 America/New_York EST';

--[er] non-existent
select datetimetz'2007-03-11 2:00:00 America/New_York';

execute trans using timestamptz'2007-03-11 1:59:59 America/New_York EST', 1, timestamptz'2007-03-11 3:00:00 America/New_York EDT';
execute make_time using datetime'2007-10-28 2:00:00', timestamptz'2007-10-28 2:00:00 America/New_York EDT';
execute trans using timestamptz'2007-11-04 1:59:59 America/New_York EDT', 1, datetimetz'2007-11-04 1:00:00 America/New_York EST';
execute trans using timestamptz'2015-03-08 1:59:59 America/New_York EST', 1, timestamptz'2015-03-08 3:00:00 America/New_York EDT';
execute trans using timestamptz'2015-11-01 1:59:59 America/New_York EDT', 1, datetimetz'2015-11-01 1:00:00 America/New_York EST';
execute trans using timestamptz'2027-03-14 1:59:59 America/New_York EST', 1, timestamptz'2027-03-14 3:00:00 America/New_York EDT';
execute trans using timestamptz'2033-11-6 1:59:59 America/New_York EDT', 1, datetimetz'2033-11-6 1:00:00 America/New_York EST';



deallocate prepare make_time;
deallocate prepare trans;
deallocate prepare sub;
deallocate prepare equal;


set timezone 'Asia/Seoul';
--+ holdcas off;
