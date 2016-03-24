--Alter table by adding some enum columns to a table that does not contain a enum column;
--+ holdcas on;

drop table if exists t1;
create table t1 (i int, j int);
alter table t1 add column e1 enum('a', 'b') collate utf8_en_ci;
show full columns from t1;

alter table t1 add column f float;
alter table t1 add column e2 enum('c', 'd') collate utf8_en_cs;
show full columns from t1;

drop table t1;

commit;
--+ holdcas off;
