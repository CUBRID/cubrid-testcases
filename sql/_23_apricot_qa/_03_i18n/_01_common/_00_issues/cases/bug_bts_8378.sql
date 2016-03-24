set names utf8;
drop table if exists tbl;
create table tbl(id int,v varchar(10) collate utf8_ja_exp);
insert into tbl values(1,'ァ'),(2,'ァー'),(3,'ぁー');
select * from tbl order by v,id;
drop tbl;
set names iso88591;
