--TEST: [Merge Statement] Merge statement does not roll back when there is an error occurred in after delete trigger action.

autocommit on;

drop table if exists t1;
drop table if exists t2;
drop table if exists trigger_action;

create table t1(id int, name varchar(20));
create table t2(id int, name varchar(20));

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'updated'), (2,'updated'), (3, 'updated');

create table trigger_action(a int unique);
create trigger trig after delete on t1 execute insert into trigger_action values(1), (1);

merge into t1
using t2
on t1.id=t2.id
when matched then
update set t1.name=t2.name
delete where t1.id=2;

select * from t1;
select if(count(*)=0, 'ok', 'nok') from t1 where name='updated';
select if(count(*)=0, 'ok', 'nok') from trigger_action;

drop trigger trig;
drop table trigger_action;
drop table t1, t2;
