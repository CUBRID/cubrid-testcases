--+ holdcas on;

drop table if exists ppt01basic;
create table ppt01basic(i1 integer, s string) collate utf8_en_cs;
show full columns from ppt01basic;
drop table ppt01basic;

create table ppt01basic(i1 integer, s string charset utf8) collate utf8_en_cs;
show full columns from ppt01basic;
drop table ppt01basic;

create table ppt01basic(i1 integer, s string charset iso88591) collate utf8_en_cs;
show full columns from ppt01basic;
drop table ppt01basic;

commit;
--+ holdcas off;
