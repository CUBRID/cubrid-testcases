--CLIENT
create table t1 class attribute (a int, b int) (i1 int, i2 int);
insert into t1 values (1, 2);

update class t1 set (a, b)=(select * from t1);
select * from t1 order by 1;
select * from class t1;

drop table t1;