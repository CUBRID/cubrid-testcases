drop table if exists t;
create table t(a integer, b string) collate utf8_en_cs;
alter table t change a a string;
show full columns from t;
drop t;