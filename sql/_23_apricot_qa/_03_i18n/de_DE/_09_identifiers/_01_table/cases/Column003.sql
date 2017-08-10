set names utf8;
Create table ßäöü你好(ßä varchar(200) unique, S#ä varchar(200) default'helloßäöü你好') charset utf8 collate utf8_bin;
insert into ßäöü你好(ßä)values('ß');
insert into ßäöü你好(ßä)values('SS');
select * from ßäöü你好 order by 1;
drop table ßäöü你好;
set names iso88591;
