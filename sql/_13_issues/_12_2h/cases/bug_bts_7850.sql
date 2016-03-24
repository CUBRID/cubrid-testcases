--TEST: [Merge Statement] Delete clause does not work when it is used together with the insert clause.


drop table if exists t1;
drop table if exists t2;
drop table if exists trigger_actions;

--server side
create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');


merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b
delete where(t1.b = 'BBB')
when not matched then
insert values(t2.a, t2.b);


select if(count(*)=3, 'ok', 'nok') from t1;


drop table t1, t2;


--client side
create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

create table trigger_actions(id int auto_increment, info varchar);
create trigger trig before delete on t1 execute insert into trigger_actions(info) values('before delete');

merge into t1
using t2
on (t1.a = t2.a)
when matched then
update
set t1.b = t2.b
delete where(t1.b = 'BBB')
when not matched then
insert values(t2.a, t2.b);


select if(count(*)=3, 'ok', 'nok') from t1;
select if(count(*)=1, 'ok', 'nok') from trigger_actions;

drop table t1, t2, trigger_actions;
