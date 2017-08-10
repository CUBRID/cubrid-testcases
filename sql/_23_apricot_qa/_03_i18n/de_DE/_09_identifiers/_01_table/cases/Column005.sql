set names utf8;
Create table ßäöü你好(ßä varchar(200) unique default'SS',öü你好 varchar(200)) charset utf8 collate utf8_bin;
insert into ßäöü你好(ßä,öü你好)values(upper('ß'),'öü你好');
insert into ßäöü你好(öü你好)values('hello');
select * from ßäöü你好 order by 1;
drop table ßäöü你好;
set names iso88591;

