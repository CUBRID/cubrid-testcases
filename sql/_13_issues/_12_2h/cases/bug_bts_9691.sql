drop table if exists t;
create table t(a int AUTO_INCREMENT);
show full columns from t;
alter table t rename a as b;
show full columns from t;
drop t;