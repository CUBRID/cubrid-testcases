--
create table t1(a enum('a', 'b', 'c', 'g'));
insert into t1 values(1), (2), (3);
create table t2(a enum('b', 'e', 'f'));
insert into t2 values(1), (2), (3);

select * from t1, t2 where t1.a=t2.a order by 1, 2;
select * from t1 inner join t2 on t1.a=t2.a order by 1, 2;
select * from t1, t2 where t1.a < t2.a order by 2, 1;
select * from t1, t2 where t1.a <> t2.a order by 1, 2;

drop table t1;
drop table t2;