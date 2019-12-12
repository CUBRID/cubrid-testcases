--+ holdcas on;

drop table if exists tcl02;
create table tcl02(i1 integer, s1 string) collate utf8_en_cs;
show full columns from tcl02;

create table tcl12 like tcl02;
show full columns from tcl12;

alter table tcl12 add column s2 string;
show full columns from tcl12;

drop table tcl02;
drop table tcl12;

commit;
--+ holdcas off;
