--test with 'Europe/Vienna' time zone

--+ holdcas on;

set timezone 'Asia/Damascus';

prepare make_time from 'select if(from_tz(?, ''Asia/Damascus'')=?, ''ok'', ''nok'')';
prepare trans from 'select if(?+?=?, ''ok'', ''nok'')';
prepare sub from 'select if(?-?=?, ''ok'', ''nok'')';
prepare equal from 'select if(?=?, ''ok'', ''nok'')';


execute equal using datetimetz'1791-12-10 02:25:12 Asia/Damascus LMT', datetimetz'1791-12-10 00:00:00 GMT';
execute make_time using datetime'1919-12-31 23:40:00', datetimetz'1919-12-31 23:40:00 Asia/Damascus LMT';
--BUG: CUBRIDSUS-17148
execute trans using datetimetz'1919-12-31 23:59:59 Asia/Damascus LMT', 1000, datetimetz'1919-12-31 23:34:48 Asia/Damascus EET';
execute trans using datetimetz'1919-12-31 23:50:12 Asia/Damascus LMT', 1512000, datetimetz'1919-12-31 23:50:12 Asia/Damascus EET';
execute equal using datetimetz'1920-01-01 00:00:00 Asia/Damascus EET', datetimetz'1919-12-31 22:00:00 UTC';

--[er] non-existent
select datetimeltz'1920-04-18 2:00:00';
--ambiguous
execute trans using datetimeltz'1920-10-03 1:00:00 Asia/Damascus EEST', 3600000, datetimetz'1920-10-03 1:00:00 Asia/Damascus EET';

execute trans using datetimeltz'1921-04-17 1:59:59', 1000, datetimeltz'1921-04-17 3:00:00';
execute trans using datetimeltz'1921-10-02 1:30:00 Asia/Damascus EEST', 3600000, datetimetz'1921-10-02 1:30:00 Asia/Damascus EET';
execute equal using datetimeltz'1922-04-16 3:00:00 Asia/Damascus EEST', datetimetz'1922-04-16 00:00:00 UTC';
execute trans using datetimeltz'1923-04-15 1:59:59.999', 1, datetimetz'1923-04-15 3:00:00 Asia/Damascus EEST';
execute sub using datetimetz'1923-10-07 1:00:00 Asia/Damascus EET', 1, datetimetz'1923-10-07 1:59:59.999 Asia/Damascus EEST';
execute make_time using datetime'1940-07-01 12:00:00', datetimeltz'1940-07-01 12:00:00 Asia/Damascus EET';
execute make_time using datetime'1952-08-01 12:00:00', datetimeltz'1952-08-01 12:00:00 Asia/Damascus EET';
execute make_time using datetime'1961-12-01 12:00:00', datetimeltz'1961-12-01 12:00:00 Asia/Damascus EET';

--[er] non-existent
select datetimetz'1962-04-29 2:00:00';

execute trans using datetimeltz'1962-10-1 1:59:59', 1000, datetimeltz'1962-10-1 1:00:00 Asia/Damascus EET';
execute sub using datetimeltz'1963-05-01 3:00:00 Asia/Damascus EEST', 1000, datetimetz'1963-05-01 1:59:59 Asia/Damascus EET';
execute trans using datetimetz'1963-09-30 00:59:59.999', 3600001, datetimeltz'1963-09-30 1:00:00 Asia/Damascus EET';
execute trans using datetimetz'1964-5-1 1:50:00 Asia/Damascus EET', 3600000, datetimetz'1964-5-1 3:50:00 Asia/Damascus EEST';
execute sub using datetimeltz'1964-10-01 2:00:00 Asia/Damascus EET', 3600001, datetimeltz'1964-10-01 1:59:59.999 Asia/Damascus EEST';
execute trans using datetimetz'1965-5-1 1:50:00 Asia/Damascus EET', 3600000, datetimetz'1965-5-1 3:50:00 Asia/Damascus EEST';
execute sub using datetimeltz'1965-09-30 1:50:50 Asia/Damascus EET', 3600000, datetimeltz'1965-09-30 1:50:50 Asia/Damascus EEST';
execute sub using datetimetz'1966-04-24 4:00:00 Asia/Damascus EEST', 7200000, datetimetz'1966-04-24 1:00:00 Asia/Damascus EET';
execute trans using datetimeltz'1966-10-01 1:50:50 Asia/Damascus EEST', 3600000, datetimeltz'1966-10-01 1:50:50 Asia/Damascus EET';
execute sub using datetimetz'1967-05-01 3:00:00 Asia/Damascus EEST', 1000, datetimetz'1967-05-01 1:59:59 Asia/Damascus EET';
execute sub using datetimetz'1967-10-01 1:59:59 Asia/Damascus EET', 3600000, datetimeltz'1967-10-01 1:59:59 Asia/Damascus EEST';

--[er] non-existent
execute make_time using datetime'1968-05-01 2:00:00', datetimeltz'1968-05-01 3:00:00 Asia/Damascus EEST';

execute trans using datetimetz'1970-5-1 1:50:00 Asia/Damascus EET', 3600000, datetimetz'1970-5-1 3:50:00 Asia/Damascus EEST';
execute trans using datetimeltz'1970-10-01 1:30:30 Asia/Damascus EEST', 3600000, datetimetz'1970-10-01 1:30:30 Asia/Damascus EET';
execute trans using datetimetz'1976-05-1 1:59:59.999 Asia/Damascus EET', 1, datetimetz'1976-05-1 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1976-10-01 1:59:59 Asia/Damascus EEST', 1, timestamptz'1976-10-01 1:00:00 Asia/Damascus EET';

--[er] non-existent
select datetimetz'1977-05-01 2:00:00';

execute trans using timestamptz'1977-09-01 1:30:59 Asia/Damascus EEST', 3600, timestamptz'1977-09-01 1:30:59 Asia/Damascus EET';
execute trans using datetimetz'1978-5-1 1:50:00 Asia/Damascus EET', 3600000, datetimetz'1978-5-1 3:50:00 Asia/Damascus EEST';
execute trans using datetimeltz'1978-09-01 1:30:30 Asia/Damascus EEST', 3600000, datetimetz'1978-09-01 1:30:30 Asia/Damascus EET';

execute equal using datetimetz'1979-10-01 8:00:00 Asia/Damascus EET', datetimeltz'1979-10-01 6:00:00 GMT'; 
execute make_time using datetime'1980-07-01 13:00:00', datetimetz'1980-07-01 13:00:00 Asia/Damascus EET';
execute make_time using datetime'1982-12-01 13:00:00', datetimetz'1982-12-01 13:00:00 Asia/Damascus EET';

execute trans using timestampltz'1983-04-09 1:59:59 Asia/Damascus EET', 1, datetimeltz'1983-04-09 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1983-10-01 1:59:59 Asia/Damascus EEST', 1, datetimetz'1983-10-01 1:00:00 Asia/Damascus EET';
execute trans using timestampltz'1984-04-09 1:59:59 Asia/Damascus EET', 1, datetimeltz'1984-04-09 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1984-10-01 1:59:59 Asia/Damascus EEST', 1, datetimetz'1984-10-01 1:00:00 Asia/Damascus EET';

execute equal using timestampltz'1985-09-01 2:00:00', datetimeltz'1985-09-01 00:00:00 UTC';

execute trans using timestampltz'1986-02-16 1:59:59 Asia/Damascus EET', 1, timestamptz'1986-02-16 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1986-10-09 1:59:59 Asia/Damascus EEST', 1, datetimetz'1986-10-09 1:00:00 Asia/Damascus EET';
execute trans using timestampltz'1987-03-01 1:59:59 Asia/Damascus EET', 1, timestamptz'1987-03-01 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1987-10-31 1:59:59 Asia/Damascus EEST', 1, datetimetz'1987-10-31 1:00:00 Asia/Damascus EET';
execute trans using timestampltz'1988-03-15 1:59:59 Asia/Damascus EET', 1, timestamptz'1988-03-15 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1988-10-31 1:59:59 Asia/Damascus EEST', 1, datetimetz'1988-10-31 1:00:00 Asia/Damascus EET';
execute trans using timestampltz'1989-03-31 1:59:59 Asia/Damascus EET', 1, timestamptz'1989-03-31 3:00:00 Asia/Damascus EEST';
execute trans using timestamptz'1989-10-01 1:59:59 Asia/Damascus EEST', 1, datetimetz'1989-10-01 1:00:00 Asia/Damascus EET';
execute trans using timestampltz'1990-04-01 1:59:59 Asia/Damascus EET', 1, timestamptz'1990-04-01 3:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1990-09-30 1:59:59 Asia/Damascus EEST', 1, datetimetz'1990-09-30 1:00:00 Asia/Damascus EET';
execute trans using timestamptz'1991-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'1991-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1991-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1991-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1992-04-07 23:59:59 Asia/Damascus EET', 1, timestamptz'1992-04-08 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1992-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1992-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1993-03-25 23:59:59 Asia/Damascus EET', 1, timestamptz'1993-03-26 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1993-09-24 23:59:59 Asia/Damascus EEST', 1, datetimetz'1993-09-24 23:00:00 Asia/Damascus EET';

--[er] non-existent
select datetimetz'1994-04-01 00:00:00';

execute trans using timestampltz'1994-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1994-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1995-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'1995-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1995-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1995-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1996-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'1996-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1996-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1996-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1997-03-30 23:59:59 Asia/Damascus EET', 1, timestamptz'1997-03-31 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1997-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1997-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1998-03-29 23:59:59 Asia/Damascus EET', 1, timestamptz'1998-03-30 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1998-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1998-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'1999-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'1999-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'1999-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'1999-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2003-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'2003-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2003-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'2003-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2005-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'2005-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2005-09-30 23:59:59 Asia/Damascus EEST', 1, datetimetz'2005-09-30 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2006-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'2006-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2006-09-21 23:59:59 Asia/Damascus EEST', 1, datetimetz'2006-09-21 23:00:00 Asia/Damascus EET';

execute trans using timestamptz'2007-03-29 23:59:59 Asia/Damascus EET', 1, timestamptz'2007-03-30 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2007-11-01 23:59:59 Asia/Damascus EEST', 1, datetimetz'2007-11-01 23:00:00 Asia/Damascus EET';

execute trans using timestamptz'2008-04-3 23:59:59 Asia/Damascus EET', 1, timestamptz'2008-04-04 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2008-10-31 23:59:59 Asia/Damascus EEST', 1, datetimetz'2008-10-31 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2009-03-26 23:59:59 Asia/Damascus EET', 1, timestamptz'2009-03-27 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2009-10-29 23:59:59 Asia/Damascus EEST', 1, datetimetz'2009-10-29 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2010-04-01 23:59:59 Asia/Damascus EET', 1, timestamptz'2010-04-02 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2010-10-28 23:59:59 Asia/Damascus EEST', 1, datetimetz'2010-10-28 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2011-03-31 23:59:59 Asia/Damascus EET', 1, timestamptz'2011-04-01 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2011-10-27 23:59:59 Asia/Damascus EEST', 1, datetimetz'2011-10-27 23:00:00 Asia/Damascus EET';

execute trans using timestamptz'2012-03-29 23:59:59 Asia/Damascus EET', 1, timestamptz'2012-03-30 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2012-10-25 23:59:59 Asia/Damascus EEST', 1, datetimetz'2012-10-25 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2015-03-26 23:59:59 Asia/Damascus EET', 1, timestamptz'2015-03-27 1:00:00 Asia/Damascus EEST';
execute trans using timestampltz'2015-10-29 23:59:59 Asia/Damascus EEST', 1, datetimetz'2015-10-29 23:00:00 Asia/Damascus EET';
execute trans using timestamptz'2024-03-28 23:59:59 Asia/Damascus EET', 1, timestamptz'2024-03-29 1:00:00 Asia/Damascus EEST';
execute trans using datetimeltz'2043-10-29 23:59:59 Asia/Damascus EEST', 1000, datetimetz'2043-10-29 23:00:00 Asia/Damascus EET';



deallocate prepare make_time;
deallocate prepare trans;
deallocate prepare sub;
deallocate prepare equal;


set timezone 'Asia/Seoul';
--+ holdcas off;
