--Alter table to drop columns of enum type;
--+ holdcas on;

create table t1(e1 enum('a', 'b')  collate utf8_en_ci, i int, e2 enum('Yes', 'No', 'Cancel')  collate utf8_en_cs, e3 enum('Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri', 'Sambata', 'Duminica') collate utf8_en_cs);
show full columns from t1;

alter table t1 add column e4 enum('a', 'b', 'c', 'd') collate utf8_en_ci;
show full columns from t1;

alter table t1 drop column e2;
show full columns from t1;

alter table t1 drop column e1;
show full columns from t1;

alter table t1 add column e1 enum('x', 'y', 'z') collate utf8_en_cs;
show full columns from t1;

alter table t1 drop column e4;
show full columns from t1;

alter table t1 add column e4 enum('a', 'b', 'c', 'd') collate utf8_en_ci;
show full columns from t1;

drop table t1;

commit;
--+ holdcas off;