--+ holdcas on;

drop table if exists tbl05;
create table tbl05(i1 integer, s1 string collate utf8_en_ci) collate utf8_en_cs;
show full columns from tbl05;

create view view05 as select i1 c1, s1 c2 from tbl05;
show full columns from view05;
drop view05;

create view view05 as select * from tbl05;
show full columns from view05;
drop view05;

--next create statements should fail
create view view05 collate utf8_en_ci as select * from tbl05;
create view view05 as select * from tbl05 collate utf8_en_ci;

create view view05 collate utf8_en_ci as select s1 from tbl05;
create view view05 as select s1 from tbl05 collate utf8_en_ci;

create view view05 collate utf8_en_ci;

drop view05;
drop tbl05;

commit;
--+ holdcas off;
