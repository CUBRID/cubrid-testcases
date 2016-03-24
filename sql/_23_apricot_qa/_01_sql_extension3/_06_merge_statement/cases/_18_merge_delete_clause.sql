--various cases with delete clause.

autocommit off;


create table t1(a int primary key, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int primary key, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

commit;

--TEST: update without where condition, delete tuples not updated by the update clause, the tuples should not be deleted
merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b
delete where t2.a=3;

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


--TEST: update with where condition, delete tuples not updated by the update clause, the tuples should not be deleted, no rows merged
merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b where t1.a > 3 
delete where t1.b='bbb';

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


--TEST: delete with conditions in the source table
merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b where t1.a < 3
delete where t2.b='BBB';

select if (count(*)=2, 'ok', 'nok') from t1;

rollback;



--TEST: with insert clause
merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b where t2.a < 3
delete where t2.b='AAA'
when not matched then
insert values(t2.a, t2.b) where t2.a < 5;

select if (count(*)=3, 'ok', 'nok') from t1;
select * from t1 order by 1;

rollback;


drop table t1, t2;
commit;


autocommit on;
