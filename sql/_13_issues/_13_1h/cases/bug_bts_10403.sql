--TEST: [I18N] charset conversion should not be performed for enum type in alter table statements.


drop table if exists t;
create table t(a enum('a', 'b') charset utf8, b varchar charset utf8);

--should fail
alter table t change a a enum('a', 'b') charset euckr;
alter table t modify a enum('a', 'b') charset euckr;
alter table t change a a enum('a', 'b') charset iso88591;
alter table t modify a enum('a', 'b') charset iso88591;
alter table t change a a enum('a', 'b') collate utf8_en_ci;
show full columns in t;
alter table t modify a enum('a', 'b') collate utf8_en_cs;
show full columns in t;
alter table t modify a enum('a', 'b') collate euckr_bin;
alter table t modify a enum('a', 'b') collate iso88591_en_cs;


--should fail
alter table t change b b varchar charset euckr;
alter table t modify b varchar charset euckr;
alter table t change b b varchar charset iso88591;
alter table t modify b varchar charset iso88591;
alter table t change b b varchar collate utf8_en_ci;
show full columns in t;
alter table t modify b varchar collate utf8_en_cs;
show full columns in t;
alter table t modify b varchar collate euckr_bin;
alter table t modify b varchar collate iso88591_en_cs;


drop table t;
