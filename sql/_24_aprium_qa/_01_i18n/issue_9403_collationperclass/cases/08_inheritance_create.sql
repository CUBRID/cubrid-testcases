--+ holdcas on;

drop table if exists parent08;
drop table if exists child08;
create table parent08(i1 integer, s1 string) collate utf8_en_cs;
show full columns from parent08;

create table child08 (i2 integer) collate utf8_en_ci;

alter table child08 add superclass parent08;
show full columns from parent08;

alter table child08 add class attribute s2 string inherit s1 of parent08;
show full columns from child08;

alter table child08 collate utf8_tr_cs;
alter table child08 add column s2 string;
show full columns from child08;

drop table child08;
drop table parent08;

commit;
--+ holdcas off;
