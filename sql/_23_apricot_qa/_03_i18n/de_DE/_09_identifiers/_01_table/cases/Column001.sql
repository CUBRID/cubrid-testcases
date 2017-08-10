set names utf8;
Create table ßäöü你好(öü int ,ßä varchar(200) SHARED'ßäöü你好', S#ä varchar(200) default'helloßäöü你好') charset utf8 collate utf8_bin;
insert into ßäöü你好(öü)values(1),(2);
select * from ßäöü你好 order by 1;
insert into ßäöü你好(öü,ßä)values(3,'SSäöü你好');
insert into ßäöü你好(öü)values(4),(5);
ALTER TABLE ßäöü你好 CHANGE S#ä  S#ä varchar(200) default'ßäöü你好';
select * from ßäöü你好 order by 1;
insert into ßäöü你好(öü)values(7);
select * from ßäöü你好 order by 1;
drop table ßäöü你好;
set names iso88591;

