--pass different formats of string arguments


--error
select time_to_sec('8:19:34 AM Asia/Seoul');
select time_to_sec('1999-11-30 9:10:10 pm Asia/Seoul');
select time_to_sec('12/12/1644 10:20:55.789 Asia/Seoul');
