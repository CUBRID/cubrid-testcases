--pass different formats of string arguments

--error
select minute('3:15:17 Asia/Seoul');
select minute('1999-11-30 9:10:10 pm Asia/Seoul');
select minute('2:22:22.333 8/12/2010 Asia/Seoul');


