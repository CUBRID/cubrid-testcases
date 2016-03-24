--create a table with two columns of type enum
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('a', 'b') collate utf8_en_ci, e2 enum('Yes', 'No', 'Cancel') collate utf8_en_ci);
show full columns from t1;

insert into t1 values (1, 1), (1, 2), (2, 3), (1, 3), (2, 1);
select * from t1 order by 1, 2;

drop table t1;

commit;
--+ holdcas off;
