drop table if exists t;
create table t(a string collate utf8_en_ci)collate utf8_en_cs;
show full columns from t;
alter table t change a a string;
show full columns from t;
drop t;