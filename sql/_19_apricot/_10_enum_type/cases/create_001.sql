--create a table with a single column and wich is of enum type

create table t1(e enum('a', 'b'));

insert into t1 values (1), (2), ('b'), ('a');

select * from t1 order by 1;

drop table t1;