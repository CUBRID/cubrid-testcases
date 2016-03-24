--Alter table to drop columns of enum type;
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('a', 'b')  collate utf8_en_cs, i int, e2 enum('Yes', 'No', 'Cancel')  collate utf8_en_ci, e3 enum('Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri', 'Sambata', 'Duminica') collate utf8_en_cs);
show full columns from t1;

alter table t1 change column e1 e1 enum('a', 'b', 'c', 'd') collate utf8_en_ci;
show full columns from t1;

alter table t1 change column e2 e2 enum('Yes', 'No', 'Cancel') collate iso88591_en_cs;
show full columns from t1;

alter table t1 change column e3 e3 e3 enum('Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri') collate iso88591_en_ci;
show full columns from t1;

drop table t1;

commit;
--+ holdcas off;
