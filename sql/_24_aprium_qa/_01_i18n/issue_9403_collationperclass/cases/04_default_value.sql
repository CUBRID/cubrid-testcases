--+ holdcas on;

drop table if exists tbl04;
create table tbl04(i1 integer, s string default 'aAa') collate utf8_en_cs;
show full columns from tbl04;

insert into tbl04 (i1) values (1);
insert into tbl04 values (2, 'AAA'), (3, 'aAb');

select * from tbl04 order by s, i1;
select * from tbl04 order by s desc, i1;

create table tbl041 (i2 integer, s2 string collate utf8_bin);
insert into tbl041 select i1, s from tbl04;
show full columns from tbl041;
select * from tbl041 order by i2;

drop table tbl041;
drop table tbl04;

commit;
--+ holdcas off;
