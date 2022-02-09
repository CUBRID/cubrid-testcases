create table t1(c1 int, c2 int, c3 int);

insert into t1 values (null, null, null);
insert into t1 values (1, 1, 1);

--TEST: should be error alert
select /*+ recompile */c2,c3 from t1 where c2<>0;


--TEST:
select c1,c2,c3 from t1 where c3 > -2147483648;
select c1,c2,c3 from t1 where c3 > -2147483649;
select c1,c2,c3 from t1 where c3 < 2147483647;
select c1,c2,c3 from t1 where c3 < 2147483648;
--TEST:


drop table t1;

