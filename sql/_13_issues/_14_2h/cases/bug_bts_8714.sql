drop table if exists t1;
drop table if exists t2;
create table t1(a int, b char(10));
create table t2(a int, b char(10));

insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(2, 'ccc');
insert into t1 values(3, 'aaa');
insert into t1 values(3, 'aaa');

insert into t2 values(1, 'AAA');
insert into t2 values(1, 'BBB');
insert into t2 values(1, 'CCC');
insert into t2 values(2, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(2, 'CCC');
insert into t2 values(2, 'DDD');
insert into t2 values(2, 'EEE');
insert into t2 values(3, 'AAA');

-- inner join
select  t1.a, t1.b, t2.b from t1 inner join t2 on t1.a=t2.a order by 1,2,3;  
select  t1.a, t1.b, t2.b from t1 inner join t2 where t1.a=t2.a order by 1,2,3;  
select  t1.a, t1.b, t2.b from t1 join t2 on t1.a=t2.a order by 1,2,3;  
select  t1.a, t1.b, t2.b from t1 join t2 where t1.a=t2.a order by 1,2,3;  

-- outer join, succeed
select  t1.a, t1.b, t2.b from t1 left join t2 on t1.a=t2.a order by 1,2,3;  
select  t1.a, t1.b, t2.b from t1 right join t2 on t1.a=t2.a order by 1,2,3;  
-- outer join, report error
select  t1.a, t1.b, t2.b from t1 left join t2 where t1.a=t2.a order by 1,2,3;  
select  t1.a, t1.b, t2.b from t1 right join t2 where t1.a=t2.a order by 1,2,3; 

-- full join, currently not support now.
-- select  t1.a, t1.b, t2.b from t1 full join t2 where t1.a=t2.a;  
-- select  t1.a, t1.b, t2.b from t1 full join t2 where t1.a=t2.a;

drop table if exists t1;
drop table if exists t2;
