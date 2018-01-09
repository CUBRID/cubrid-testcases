--+ holdcas on;

drop table if exists tbl121;
drop table if exists tbl12;

CREATE TABLE tbl12 ( id INT, s1 VARCHAR SHARED 'AAA') collate utf8_en_cs;
insert into tbl12 values (1, 'A');
select * from tbl12 order by 1,2;
insert into tbl12 values (2, 'B');
select * from tbl12 order by 1,2;
show full columns from tbl12;

alter table tbl12 add column s2 string charset utf8 shared 'C';
alter table tbl12 add column s3 string charset iso88591 shared 'D';
alter table tbl12 add column s4 string collate iso88591_bin shared 'E';
show full columns from tbl12;

create table tbl121 as select * from tbl12;
show full columns from tbl121;
select * from tbl121 order by 1,2;

drop tbl121;
drop tbl12;

commit;
--+ holdcas off;
