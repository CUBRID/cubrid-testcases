set names utf8;
Create table ßäöü你好(ßÄ varchar(200) primary key)charset utf8 collate utf8_bin;
insert into ßäöü你好 values('ß');
insert into ßäöü你好 values('SS');
insert into ßäöü你好 values('a');
insert into ßäöü你好 values('A');
select * from ßäöü你好 order by 1;
drop table ßäöü你好;
set names iso88591;
