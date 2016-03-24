--pass different formats of string arguments

--error
select hour('3:15:17 Asia/Seoul');
select hour('1999-11-30 9:10:10 pm Asia/Seoul');
select hour('2038--01-19 3:14:7 Asia/Seoul');
select hour('25:30:59 pm');
select hour('2020-23-11 03:14:66 pm');
