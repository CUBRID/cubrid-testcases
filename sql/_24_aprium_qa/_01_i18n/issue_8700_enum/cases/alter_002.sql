--Alter table by adding some enum columns to a table that contains a enum column;
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('a', 'b', 'c') collate utf8_en_cs);
show full columns from t1;

alter table t1 add column e2 enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '0') collate utf8_en_ci;
show full columns from t1;

drop table t1;

commit;
--+ holdcas off;
