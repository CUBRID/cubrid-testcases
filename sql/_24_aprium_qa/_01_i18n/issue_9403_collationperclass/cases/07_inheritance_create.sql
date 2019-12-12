--+ holdcas on;

drop table if exists parent07;
drop table if exists child07;
create class parent07(i1 integer, s1 string) collate utf8_en_cs;
show full columns from parent07;

create class child07 as subclass of parent07 (s2 string, s3 string collate utf8_en_ci);
show full columns from child07;
drop child07;

create class child07 as subclass of parent07 (s2 string, s3 string collate utf8_bin) collate utf8_en_ci;
show full columns from child07;
drop child07;

drop table parent07;

commit;
--+ holdcas off;
