--create a table with two columns of type enum
create table t1(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'));

insert into t1 values (1, 1), (1, 2), (2, 3), (1, 3), (2, 1);
select * from t1 order by 1, 2;

drop table t1;