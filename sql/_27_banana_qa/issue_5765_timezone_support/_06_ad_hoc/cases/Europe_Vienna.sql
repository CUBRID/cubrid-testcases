--test with 'Europe/Vienna' time zone

--+ holdcas on;

set timezone 'Europe/Vienna';

prepare make_time from 'select if(from_tz(?, ''Europe/Vienna'')=?, ''ok'', ''nok'')';
prepare trans from 'select if(?+?=?, ''ok'', ''nok'')';
prepare equal from 'select if(?=?, ''ok'', ''nok'')';


execute make_time using datetime'1893-03-31 23:59:59', datetimetz'1893-03-31 23:59:59 Europe/Vienna LMT';

--test: ambiguous time transition
--BUG: CUBRIDSUS-17063
select if(datetimetz'1893-03-31 23:59:59.999'+1=datetimetz'1893-03-31 23:54:39 Europe/Vienna CET', 'ok', 'nok');
--test: ambiguous time
select datetimetz'1893-03-31 23:58:00 Europe/Vienna LMT';
select datetimetz'1893-03-31 23:58:00 Europe/Vienna CET';

execute equal using datetimetz'1893-04-01 12:00:00 AM Europe/Vienna CET', datetimetz'1893-03-31 23:00:00 UTC';

execute make_time using datetime'1915-07-01 3:00:00', datetimetz'1915-07-01 3:00:00 Europe/Vienna CET';
execute make_time using datetime'1916-07-01 3:00:00', datetimetz'1916-07-01 3:00:00 Europe/Vienna CEST';

--[er] non-existent
select datetimetz'1916-04-30 23:00:00';

execute make_time using datetime'1916-05-01 00:00:00', datetimetz'1916-05-01 00:00:00 Europe/Vienna CEST';
execute trans using datetimetz'1916-10-01 00:59:59', 1000, datetimetz'1916-10-01 00:00:00 Europe/Vienna CET';

--[er] non-existent
execute datetime'1918-04-15 2:00:00', '1918-04-15 2:00:00';

execute trans using datetimetz'1918-09-16 2:59:59 Europe/Vienna CEST', 1000, datetimetz'1918-09-16 2:00:00 Europe/Vienna CET';
execute trans using datetimetz'1919-12-31 23:59:59.990', 10, datetimeltz'1920-01-01 00:00:00';

execute make_time using datetime'1920-01-01 00:00:00', datetimetz'1920-01-01 00:00:00 Europe/Vienna CET';

execute trans using datetimetz'1920-04-05 1:59:59 Europe/Vienna CET', 1000, '1920-04-05 3:00:00 Europe/Vienna CEST';
execute trans using datetimetz'1920-09-13 2:00:00 Europe/Vienna CEST', 3600000, '1920-09-13 2:00:00 Europe/Vienna CET';
execute make_time using datetime'1930-07-01 2:00:00', datetimetz'1930-07-01 2:00:00 Europe/Vienna CET';

--[er] non-existent
--BUG: CUBRIDSUS-17676
select datetimetz'1940-04-01 2:00:00 Europe/Vienna';

execute trans using datetimetz'1940-04-01 1:59:59 Europe/Vienna CET', 1000, datetimetz'1940-04-01 3:00:00 Europe/Vienna CEST';
execute equal using datetimetz'1940-12-01 2:00:00 Europe/Vienna CEST', datetimetz'1940-12-01 00:00:00 UTC';
execute make_time using datetime'1941-10-15 23:33:12', datetimetz'1941-10-15 23:33:12 Europe/Vienna CEST';
--BUG: CUBRIDSUS-17132
execute make_time using datetime'1942-07-15 23:33:12', datetimetz'1942-07-15 23:33:12 Europe/Vienna CEST';
execute trans using datetimetz'1942-11-02 2:59:59 Europe/Vienna CEST', 1000, datetimetz'1942-11-02 2:00:00 Europe/Vienna CET';
execute make_time using datetime'1943-01-20 5:00:00', datetimetz'1943-01-20 5:00:00 Europe/Vienna CET';

--[er] non-existent
select datetimetz'1943-03-29 2:00:00 Europe/Vienna';

--BUG: CUBRIDSUS-17132
execute equal using datetimetz'1942-05-11 12:00:00 Europe/Vienna', datetimetz'1942-05-11 10:00:00 GMT';
execute trans using datetimetz'1943-10-04 2:30:30 Europe/Vienna CEST', 3600000, datetimetz'1943-10-04 2:30:30 Europe/Vienna CET';
execute trans using datetimetz'1944-04-03 1:59:59 Europe/Vienna CET', 1000, datetimetz'1944-04-03 3:00:00 Europe/Vienna CEST';
execute trans using datetimetz'1944-10-02 2:59:59 Europe/Vienna CEST', 1000, datetimetz'1944-10-02 2:00:00 Europe/Vienna CET';
--BUG: CUBRIDSUS-17135
--BUG: CUBRIDSUS-17677
execute trans using datetimetz'1945-04-02 1:59:59 Europe/Vienna CET', 1000, datetimetz'1945-04-02 3:00:00 Europe/Vienna CEST';

execute trans using datetimetz'1945-04-12 2:59:59 Europe/Vienna CEST', 1000, '1945-04-12 2:00:00 Europe/Vienna CET';
execute make_time using datetime'1945-08-01 00:00:00', datetimetz'1945-08-01 00:00:00 Europe/Vienna CET';
execute make_time using datetime'1946-01-01 00:00:00', datetimetz'1946-01-01 00:00:00 Europe/Vienna CET';

--[er] non-existent
select datetimetz'1946-4-14 2:00:00 Europe/Vienna';

execute trans using datetimetz'1946-10-06 2:30:30 Europe/Vienna CEST', 3600000, datetimetz'1946-10-06 2:30:30 Europe/Vienna CET';
execute trans using datetimetz'1947-04-06 1:30:00 Europe/Vienna CET', 3600000, datetimetz'1947-04-06 3:30:00 Europe/Vienna CEST';
execute trans using datetimetz'1946-10-06 2:59:59 Europe/Vienna CEST', 1000, datetimetz'1946-10-06 2:00:00 Europe/Vienna CET';
execute trans using datetimetz'1948-04-18 1:59:59 Europe/Vienna CET', 1000, datetimetz'1948-04-18 3:00:00 Europe/Vienna CEST';
execute trans using datetimetz'1948-10-03 2:30:30 Europe/Vienna CEST', 3600000, datetimetz'1948-10-03 2:30:30 Europe/Vienna CET';
execute equal using datetimetz'1960-09-10 14:00:00 Europe/Vienna CET', datetimetz'1960-09-10 13:00:00 UTC';
execute trans using timestamptz'1980-04-05 23:59:59 Europe/Vienna CET', 1, datetimetz'1980-04-06 1:00:00 Europe/Vienna CEST';
execute trans using timestamptz'1980-09-27 23:59:59 Europe/Vienna CEST', 1, datetimetz'1980-09-27 23:00:00 Europe/Vienna CET';
execute make_time using datetime'1981-01-01 00:00:00', timestamptz'1981-01-01 00:00:00 Europe/Vienna CET';
execute trans using timestampltz'1981-03-29 1:59:59 Europe/Vienna CET', 1, timestampltz'1981-03-29 3:00:00 Europe/Vienna CEST';
execute trans using timestamptz'1981-09-27 2:59:59 Europe/Vienna CEST', 1, timestamptz'1981-09-27 2:00:00 Europe/Vienna CET';
execute trans using timestamptz'1994-03-27 1:59:59 Europe/Vienna CET', 1, timestampltz'1994-03-27 3:00:00 Europe/Vienna CEST';
execute trans using timestamptz'1994-09-25 2:30:30 Europe/Vienna CEST', 3600, datetimetz'1994-09-25 2:30:30 Europe/Vienna CET';
execute trans using timestamptz'1996-03-31 1:59:59 Europe/Vienna CET', 3600, timestamptz'1996-03-31 3:59:59 Europe/Vienna CEST';
execute trans using timestamptz'1996-10-27 2:59:59 Europe/Vienna CEST', 1, timestamptz'1996-10-27 2:00:00 Europe/Vienna CET';
execute trans using datetimetz'2015-03-29 1:30:00 Europe/Vienna CET', 3600000, datetimetz'2015-03-29 3:30:00 Europe/Vienna CEST';
execute trans using datetimetz'2015-10-25 2:30:30 Europe/Vienna CEST', 3600000, datetimetz'2015-10-25 2:30:30 Europe/Vienna CET';
execute trans using timestamptz'2018-03-25 1:59:59 Europe/Vienna CET', 1, timestamptz'2018-03-25 3:00:00 Europe/Vienna CEST';
execute trans using timestamptz'2027-10-31 2:59:59 Europe/Vienna CEST', 1, timestamptz'2027-10-31 2:00:00 Europe/Vienna CET';


deallocate prepare make_time;
deallocate prepare trans;
deallocate prepare equal;


set timezone 'Asia/Seoul';
--+ holdcas off;
