--+ holdcas on;

drop table ppt02basic;
create table ppt02basic(i1 integer, s1 string collate utf8_en_ci) collate utf8_en_cs;
show full columns from ppt02basic;

alter table ppt02basic add column s2 string;
alter table ppt02basic add column s3 string charset utf8;
alter table ppt02basic add column s4 string charset iso88591;
alter table ppt02basic add column s5 string collate utf8_tr_cs;
show full columns from ppt02basic;
drop table ppt02basic;

create table ppt02basic(i1 integer, s1 string collate utf8_en_ci) charset utf8;
show full columns from ppt02basic;

alter table ppt02basic add column s2 string;
alter table ppt02basic add column s3 string charset utf8;
alter table ppt02basic add column s4 string charset iso88591;
alter table ppt02basic add column s5 string collate utf8_tr_cs;
show full columns from ppt02basic;
drop table ppt02basic;

commit;
--+ holdcas off;
