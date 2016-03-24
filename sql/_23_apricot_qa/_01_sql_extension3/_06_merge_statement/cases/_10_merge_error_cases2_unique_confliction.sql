--error case testing

autocommit off;


create table t1(id int primary key, name varchar(20) not null);
create table t2(id int, name varchar(20) unique);

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max'), (8, 'inserted');


--TEST: create triggers
create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before statement update on t1 execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after statement insert on t1 execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 before statement update on t2 execute insert into trigger_actions2(info) values ('updated');
create trigger trigg4 after statement insert on t2 execute insert into trigger_actions2(info) values ('inserted');


commit;

-- ######################### CASE 1 ############################### --
--TEST: error, pk violation error
merge into t1
using t2
on (t1.id=t2.id)
when matched then
update
set t1.name=t2.name
where t2.id < 3
when not matched then 
insert
values((t2.id-3), t2.name)
where t2.id < 10;

--TEST: check update result
select * from t1;
select if(count(*)=0, 'ok', 'nok') from t1 where name in ('George', 'Laura');
select if(count(*)=0, 'ok', 'nok') from trigger_actions1;

rollback;



-- ######################### CASE 2 ############################### --
--TEST: error, unique violation error
merge into t2
using t1
on (t1.id=t2.id)
when matched then 
update
set t2.name='updated'
when not matched then 
insert
values(t1.id, t1.name);

--TEST: check update result
select * from t1;
select if(count(*)=0, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=4, 'ok', 'nok') from t2;
select if(count(*)=0, 'ok', 'nok') from trigger_actions2;

rollback;


-- ######################### CASE 3 ############################### --
--TEST: error, not null violation error
merge into t1
using t2
on (t1.id=t2.id)
when matched then
update
set t1.name='updated'
when not matched then
insert
values(t2.id, null);

--TEST: check update result
select * from t1;
select if(count(*)=0, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=4, 'ok', 'nok') from t2;
select if(count(*)=0, 'ok', 'nok') from trigger_actions2;

rollback;



drop trigger trigg1, trigg2, trigg3, trigg4
drop table t2, t1, trigger_actions1, trigger_actions2;

commit;


autocommit on;
