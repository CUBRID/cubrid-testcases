--How not to use enum in column creation
--+ holdcas on;

drop table if exists t1;
create table t1(enum_col enum);
show full columns from t1;
drop table t1;

create table t1(enum_col enum());
show full columns from t1;
drop table t1;

create table t1(enum_col enum('a', 'b', 'c', 'a', 'd') collate utf8_en_cs);
show full columns from t1;
drop table t1;

create table t1(enum_col enum('aa', 'Aa') collate utf8_en_ci);
show full columns from t1;
drop table t1;

create table t1(enum_col enum('aA', 'aa') collate utf8_en_ci);
show full columns from t1;
drop table t1;

commit;
--+ holdcas off;
