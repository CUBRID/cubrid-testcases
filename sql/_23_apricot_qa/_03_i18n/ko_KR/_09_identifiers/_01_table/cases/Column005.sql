set names utf8;
Create table 가댁체힐你好(가댁 varchar(200) unique default'SS',체힐你好 varchar(200)) charset utf8 collate utf8_bin;
insert into 가댁체힐你好(가댁,체힐你好)values(upper('가'),'체힐你好');
insert into 가댁체힐你好(체힐你好)values('hello');
SELECT * FROM 가댁체힐你好 order by 1;
drop table 가댁체힐你好;
set names iso88591;