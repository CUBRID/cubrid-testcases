--+ holdcas on;

drop table if exists tbl06;
create table tbl06(i1 integer, s1 string collate utf8_en_ci) collate utf8_en_cs;
show full columns from tbl06;

create view view06 as select i1 c1, s1 c2 from tbl06;
show full columns from view06;

alter view06 drop column c1;
show full columns from view06;

alter view06 add column c3 string;
alter view06 add column c4 string collate utf8_en_cs;

show full columns from tbl06;
show full columns from view06;
drop view06;


create view view06 as select * from tbl06;
show full columns from view06;

alter view06 add column c3 string;
alter view06 add column c4 string collate utf8_en_cs;

show full columns from tbl06;
show full columns from view06;
drop view06;

drop tbl06;

commit;
--+ holdcas off;
