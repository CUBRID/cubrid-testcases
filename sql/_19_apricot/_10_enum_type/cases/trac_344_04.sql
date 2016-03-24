--
create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5);

select * from t1 where e1 in (select e1 from t1 where e1 < 5) order by 1, 2;

drop table t1;
