--TEST: [Merge Statement] 'System error (merge insert) in ../../src/query/execute_statement.c (line: 14868)' error occurs when doing implicit insert in the insert clause.

drop table if exists t1;
drop table if exists t2;

--server side
create table t1(id int primary key, name varchar(20));
create table t2(id int, name varchar(20) unique);

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd');
insert into t2 values(1,'a'),(2,'b'),(3,'c'), (5, 'inserted1'), (8, 'inserted2');


merge into t1
using t2 
on (t1.id=t2.id)
when matched then
update 
set t1.name='updated'
when not matched then
insert(t1.name)
values(t2.name);

select if(count(*)=0, 'ok', 'nok') from t1 where name='updated';

drop table t1, t2;


--client side
create table t1(id int primary key, name varchar(20));
create table t2(id int, name varchar(20) unique);

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd');
insert into t2 values(1,'a'),(2,'b'),(3,'c'), (5, 'inserted1'), (8, 'inserted2');

create table trigger_actions(id int auto_increment, info string);
create trigger trigg1 after update on t1 execute insert into trigger_actions(info) values('updated');
create trigger trigg2 after insert on t1 execute insert into trigger_actions(info) values('inserted');

merge into t1
using t2 
on (t1.id=t2.id)
when matched then
update 
set t1.name='updated'
when not matched then
insert(t1.name)
values(t2.name);

select if(count(*)=0, 'ok', 'nok') from t1 where name='updated';
select if(count(*)=0, 'ok', 'nok') from trigger_actions;

drop trigger trigg1, trigg2;
drop table trigger_actions;
drop table t1, t2;

