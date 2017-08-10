--+ holdcas on;

drop table if exists ppt01basic;
create table ppt01basic(i1 integer auto_increment, s string) collate utf8_en_cs, auto_increment=2, collate utf8_en_ci, auto_increment=2, reuse_oid, reuse_oid;

create table ppt01basic(i1 integer, s string) charset iso88591 collate utf8_en_cs;


commit;
--+ holdcas off;
