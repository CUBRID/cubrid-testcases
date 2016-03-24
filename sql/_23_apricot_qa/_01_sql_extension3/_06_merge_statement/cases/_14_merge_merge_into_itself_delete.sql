--merge into a table using itself

autocommit off;


create table t1(id int primary key, name varchar(20) not null);
create table t2(id int primary key, name varchar(20));

insert into t1 values(1,'aaa'), (2,'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max'), (8, 'inserted');


--TEST: create triggers
create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before statement update on t1 execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after statement insert on t1 execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 before statement delete on t1 execute insert into trigger_actions1(info) values ('deleted');
create trigger trigg4 before statement update on t2 execute insert into trigger_actions2(info) values ('updated');
create trigger trigg5 after statement insert on t2 execute insert into trigger_actions2(info) values ('inserted');
create trigger trigg6 after statement delete on t2 execute insert into trigger_actions2(info) values ('deleted');


commit;

-- ######################### CASE 1 ############################### --
--TEST: merge into itself, without insert clause
merge into t1 t1
using t1 t2
on (t1.id=t2.id)
when matched then
update
set t1.name=t2.name
delete where t2.id=1;


--TEST: check update result
select * from t1 order by 1,2;
select if(count(*)=2, 'ok', 'nok') from trigger_actions1;

rollback;



-- ######################### CASE 2 ############################### --
--TEST: merge into itself, with insert clause
merge into t2 t1
using t2 t2
on (t1.id=t2.id)
when matched then 
update
set t1.name='updated'
where t1.id < 4
delete where t2.id > 1
when not matched then 
insert
values(t2.id, t2.name);

--TEST: check update result
select if(count(*)=1, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=2, 'ok', 'nok') from t2;
select if(count(*)=3, 'ok', 'nok') from trigger_actions2;

rollback;


-- ######################### CASE 3 ############################### --
--TEST: update with where clause
merge into t1 t1
using t1 t2
on (t1.id=t2.id)
when matched then
update
set t1.name=t2.name
where t1.id > 2
delete where t2.id < 10
when not matched then
insert
values(t2.id, null);

--TEST: check update result
select * from t1 order by 1,2;
select if(count(*)=2, 'ok', 'nok') from t1;
select if(count(*)=3, 'ok', 'nok') from trigger_actions1;

rollback;



drop trigger trigg1, trigg2, trigg3, trigg4, trigg5, trigg6;
drop table t2, t1, trigger_actions1, trigger_actions2;

commit;


autocommit on;
