--test string functions with TIMESTAMP(L)TZ constant values as arguments


set timezone 'Europe/Paris';
--test: concatenation operator, with constant ts values as operands
select timestampltz'1979-10-11 23:46:44'+'1979-10-11 23:46:44';
select timestamptz'1979-10-11 23:46:44 -4:00'+'1979-10-11 23:46:44';
select timestampltz'1979-10-11 23:46:44 CET'+'1979-10-11 23:46:44';
select timestamptz'1979-10-11 23:46:44'||'1979-10-11 23:46:44';
select timestampltz'1979-10-11 23:46:44 -4:00'||timestamp'1979-10-11 23:46:44';
select timestamptz'1979-10-11 23:46:44 CET'||timestampltz'1979-10-11 23:46:44 Asia/Seoul';

select char_length(timestampltz'1979-10-11 23:46:44 -4:00');
select char_length(timestamptz'1979-10-11 23:46:44 Asia/Seoul');
select length(timestampltz'1979-10-11 23:46:44 -4:00');
select length(timestamptz'1979-10-11 23:46:44 Asia/Seoul');

select concat(timestampltz'1979-10-11 23:46:44 CET', 2, '1979-10-11 23:46:44');
select lcase(timestamptz'1979-10-11 23:46:44 Asia/Seoul');
select upper(timestamptz'1979-10-11 23:46:44 -12:00');
select trim(timestampltz'1979-10-11 23:46:44 Europe/Paris');
select if(substr(timestamptz'1979-10-11 23:46:44 Europe/Paris', 24, 6)='Europe', 'ok', 'nok');
select if(position('Europe' in timestampltz'1979-10-11 23:46:44 Europe/Paris')=24, 'ok', 'nok');
select repeat(timestamptz'1979-10-11 23:46:44 Asia/Seoul', 10);


set timezone 'Asia/Seoul';
