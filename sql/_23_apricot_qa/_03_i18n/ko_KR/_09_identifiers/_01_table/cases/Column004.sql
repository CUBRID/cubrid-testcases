set names utf8;
Create table 가댁체힐你好(가댁 varchar(200) unique, S#댁 varchar(200) default'hello가댁체힐你好') charset utf8 collate utf8_bin;
insert into 가댁체힐你好(가댁)values(upper('가'));
insert into 가댁체힐你好(가댁)values('SS');
insert into 가댁체힐你好(가댁)values('a');
insert into 가댁체힐你好(가댁)values('A');
SELECT * FROM 가댁체힐你好 order by 1;
drop table 가댁체힐你好;
set names iso88591;