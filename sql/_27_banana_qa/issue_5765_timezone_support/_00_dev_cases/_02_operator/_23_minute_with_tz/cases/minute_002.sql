--pass different formats of string arguments

--error
select minute('3:15:17 Asia/Seoul');
select minute('2009-1-09 4:30:01 am Asia/Seoul');

