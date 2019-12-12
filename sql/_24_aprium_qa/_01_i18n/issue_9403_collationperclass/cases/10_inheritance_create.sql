--+ holdcas on;

drop table if exists ch101;
drop table if exists ch102;
drop table if exists child101;
drop table if exists child102;
drop table if exists parent101;
drop table if exists parent102;

create class parent101(i1 integer, s1 string) collate utf8_en_cs;
show full columns from parent101;

create class parent102(i2 integer, s2 string) collate utf8_en_ci;
show full columns from parent102;

create class child101 under parent101, parent102 (ic integer, sc string) collate utf8_tr_cs inherit s1 of parent101;
alter class child101 add column new1 string;
show full columns from child101;

create class child102 under parent101, parent102 (ic integer, sc string) collate utf8_ko_cs inherit s2 of parent102;
alter class child102 add column new2 string;
show full columns from child102;

create class ch101 under child101 (scc string);
show full columns from ch101;

create class ch102 under child102 (scc string);
show full columns from ch102;

drop table ch101;
drop table ch102;
drop table child101;
drop table child102;
drop table parent101;
drop table parent102;

commit;
--+ holdcas off;
