drop table if exists x1;
set names utf8;
create table x1 (a varchar(100) charset iso88591 collate iso88591_en_ci);
insert into x1 values (X'41');
insert into x1 values (0x41);
select * from x1;
drop x1;
set names iso88591;
