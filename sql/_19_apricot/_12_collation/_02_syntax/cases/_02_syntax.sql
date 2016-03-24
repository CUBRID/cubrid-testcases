
-- error
create table t1 (s1 string charset iso collate 'utf8_en_ci');

-- error
create table t1 (s1 string charset bad_charset collate 'utf8_en_ci');

create table t1 (s1 string charset utf8 collate 'utf8_en_ci');

drop table t1;

create table t1 (s1 char(10) charset utf8 collate 'utf8_en_ci');

drop table t1;


create table t1 (s1 char(10) character_set utf8 collate 'utf8_en_ci');

drop table t1;

create table t1 (s1 char(10) character_set 'utf8' collate 'utf8_en_ci');

drop table t1;

create table character_set;

drop table character_set;

