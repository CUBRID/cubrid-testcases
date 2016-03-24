--TEST: support delete join syntax


autocommit off;

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

commit;

delete t1 from t1 inner join t2 on t1.a=t2.a;
select if(count(*)=0, 'ok', 'nok') from t1;
rollback;

--[er] snytax error
delete t1, t2 from t1 inner join t2 where t1.a=t2.a;

delete t1, t2 from t1 inner join t2 on t1.a=t2.a where t1.a < 5;
select if(count(*)=0, 'ok', 'nok') from t1;
select if(count(*)=0, 'ok', 'nok') from t1;
rollback;

delete t1, t2 from t1 left outer join t2 on t1.a=t2.a where t2.b != 'abc';
select if(count(*)=0, 'ok', 'nok') from t1;
select if(count(*)=0, 'ok', 'nok') from t1;
rollback;

delete t1, t2 from t1 right outer join t2 on t1.a=t2.a where t2.a > 0;
select if(count(*)=0, 'ok', 'nok') from t1;
select if(count(*)=0, 'ok', 'nok') from t1;
rollback;

drop table t1, t2;

commit;


autocommit on;
