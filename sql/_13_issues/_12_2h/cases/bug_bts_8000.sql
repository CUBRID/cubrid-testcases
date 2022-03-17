--TEST: [Merge Statement] When there is a trigger on the target table, the merge statement does not roll back while pk violation error occurs.

--+ holdcas on;

drop table if exists t1;
drop table if exists t2;

--server side
create table t1(id int primary key, name varchar(20) not null);
create table t2(id int, name varchar(20) unique);

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max'), (8, 'inserted');

--pk violation error
merge into t1
using t2 
on (t1.id=t2.id)
when matched then
update 
set t1.name='updated'
when not matched then
insert
values(1, t2.name);

select if(count(*)=0, 'ok', 'nok') from t1 where name='updated';
select if(count(*)=0, 'ok', 'nok') from t1 where name='inserted';

drop table t1, t2;


--client side
create table t1(id int primary key, name varchar(20) not null);
create table t2(id int, name varchar(20) unique);

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max'), (8, 'inserted');

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on t1 execute insert into trigger_actions(info) values ('before update');

--pk violation error
merge into t1
using t2 
on (t1.id=t2.id)
when matched then
update 
set t1.name='updated'
when not matched then
insert
values(1, t2.name);

select if(count(*)=0, 'ok', 'nok') from t1 where name='updated';
select if(count(*)=0, 'ok', 'nok') from t1 where name='inserted';
select if(count(*)=0, 'ok', 'nok') from trigger_actions;


drop trigger trigg1;
drop table trigger_actions;
drop table t1, t2;


commit;

--+ holdcas off;
