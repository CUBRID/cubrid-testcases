set names utf8;
Create table 가댁체힐你好(가댁 varchar(200) primary key) charset utf8 collate utf8_bin;
insert into 가댁체힐你好 values('가');
insert into 가댁체힐你好 values('SS');
insert into 가댁체힐你好 values('a');
insert into 가댁체힐你好 values('A');
select * from 가댁체힐你好 order by 1;
drop table 가댁체힐你好;
set names iso88591;
