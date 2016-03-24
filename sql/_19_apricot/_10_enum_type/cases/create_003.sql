--create table with two columns of type enum and columns of other types.
create table t1 (i int, e1 enum('a', 'b'), f float, d double, s string, e2 enum('Yes', 'No', 'Cancel'));

insert into t1 values (1, 1, 1, 1, '1', 1);
insert into t1 values (2, 'b', 2, 2, '2', 'No');
insert into t1 values (3, 1, 3, 3, '3', 'Cancel');

select * from t1 order by 1, 2, 3, 4, 5, 6;

drop table t1;