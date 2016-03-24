--create a table with a single column and wich is of enum type
--+ holdcas on;

drop table if exists t1;
create table t1(enum_col enum('a', 'b') collate utf8_en_cs);
show full columns from t1;

insert into t1 values (1), (2), ('b'), ('a');
select * from t1 order by 1;

drop table t1;

commit;
--+ holdcas off;
