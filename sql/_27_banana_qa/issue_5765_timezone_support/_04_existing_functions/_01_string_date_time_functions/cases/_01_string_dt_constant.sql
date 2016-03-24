--test string functions with DATETIME(L)TZ constant values as arguments


set timezone 'Europe/Paris';
--test: concatenation operator, with constant ts values as operands
select datetimeltz'1979-10-11 23:46:44.999'+'1979-10-11 23:46:44.999';
select datetimetz'1979-10-11 23:46:44.999 -4:00'+'1979-10-11 23:46:44.999';
select datetimeltz'1979-10-11 23:46:44.999 CET'+'1979-10-11 23:46:44.999';
select datetimetz'1979-10-11 23:46:44.999'||'1979-10-11 23:46:44.999';
select datetimeltz'1979-10-11 23:46:44.999 -4:00'||datetime'1979-10-11 23:46:44.999';
select datetimetz'1979-10-11 23:46:44.999 CET'||datetimeltz'1979-10-11 23:46:44.999 Asia/Seoul';

select char_length(datetimeltz'1979-10-11 23:46:44.999 -4:00');
select char_length(datetimetz'1979-10-11 23:46:44.999 Asia/Seoul');
select length(datetimeltz'1979-10-11 23:46:44.999 -4:00');
select length(datetimetz'1979-10-11 23:46:44.999 Asia/Seoul');

select concat(datetimeltz'1979-10-11 23:46:44.999 CET', 2, '1979-10-11 23:46:44.999');
select lcase(datetimetz'1979-10-11 23:46:44.999 Asia/Seoul');
select upper(datetimetz'1979-10-11 23:46:44.999 -12:00');
select trim(datetimeltz'1979-10-11 23:46:44.999 Europe/Paris');
select if(substr(datetimetz'1979-10-11 23:46:44.999 Europe/Paris', 28, 6)='Europe', 'ok', 'nok');
select if(position('Europe' in datetimeltz'1979-10-11 23:46:44.999 Europe/Paris')=28, 'ok', 'nok');
select repeat(datetimetz'1979-10-11 23:46:44.999 Asia/Seoul', 10);


set timezone 'Asia/Seoul';
