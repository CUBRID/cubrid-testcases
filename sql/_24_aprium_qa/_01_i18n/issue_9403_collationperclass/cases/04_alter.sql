--+ holdcas on;

drop table if exists ppt03basic;
create table ppt03basic(i1 integer) collate utf8_en_cs;
show full columns from ppt03basic;

alter table ppt03basic add column s1 string;
show full columns from ppt03basic;

alter table ppt03basic collate utf8_en_ci;
show full columns from ppt03basic;

alter table ppt03basic add column s2 string;
show full columns from ppt03basic;

drop table ppt03basic;

commit;
--+ holdcas off;
