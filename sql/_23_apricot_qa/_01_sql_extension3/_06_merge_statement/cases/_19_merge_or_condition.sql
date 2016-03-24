--use OR condition in filter predicate

autocommit off;

create table t1(a bigint, b int, c char(10));
insert into t1 values(1, 1, 'aaa');
insert into t1 values(2, 3, 'bbb');
insert into t1 values(3, 5, 'ccc');
insert into t1 values(4, 11, 'aaa');
insert into t1 values(5, 13, 'bbb');
insert into t1 values(6, 15, 'ddd');

create table t2(a smallint, b bigint, c varchar(10));
insert into t2 values(1, 12, 'AAA');
insert into t2 values(3, 4, 'AAA');
insert into t2 values(5, 3, 'AAA');
insert into t2 values(7, 15, 'AAA');
insert into t2 values(9, 11, 'AAA');
insert into t2 values(11, 5, 'AAA');
insert into t2 values(22, 22, 'BBB');
insert into t2 values(33, 33, 'BBB');
insert into t2 values(44, 44, 'BBB');

commit;



--TEST: error in oracle, with or condition, update clause only, unable to get a stable set of rows in the source tables
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when matched then
update set t1.c=t2.c;

select if(count(*)=0, 'ok', 'nok') from t1 where c='AAA';
rollback;


--TEST: with or condition, update clause only
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when matched then
update set t1.c=t2.c
where t2.a !=11;

select if(c='AAA', 'ok', 'nok') from t1;
rollback;


--TEST: update+delete
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when matched then
update set t1.c=t2.c
where t2.a !=11
delete where t1.b < 10;

select if(count(*)=3, 'ok', 'nok') from t1 where c='AAA';
rollback;


--TEST: insert only
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when not matched then
insert values(t2.a, t2.b, t2.c);

select if(count(*)=3, 'ok', 'nok') from t1 where c='BBB';
rollback;


--TEST: update+insert
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when matched then
update set t1.c=t2.c
where t2.a !=11
when not matched then
insert values(t2.a, t2.b, t2.c);

select if(count(*)=6, 'ok', 'nok') from t1 where c='AAA';
select if(count(*)=3, 'ok', 'nok') from t1 where c='BBB';
rollback;


--TEST: udpate+delete+insert
merge into t1
using t2
on (t1.a=t2.a or t1.b=t2.b)
when matched then
update set t1.c=t2.c
where t2.a !=11
delete where t1.b < 10
when not matched then
insert values(t2.a, t2.b, t2.c);

select if(count(*)=6, 'ok', 'nok') from t1;
select if(count(*)=3, 'ok', 'nok') from t1 where c='AAA';
select if(count(*)=3, 'ok', 'nok') from t1 where c='BBB';
rollback;


drop table t1, t2;
commit;


autocommit on;
