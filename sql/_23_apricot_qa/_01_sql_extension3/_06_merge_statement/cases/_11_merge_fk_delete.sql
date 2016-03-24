--target table with foreign key constraint

autocommit off;


create table t1(id int primary key, phone varchar(20));

create table t2(id int primary key, 
name varchar(20) not null, 
constraint fk_id foreign key(id) references t1(id)
on update restrict);

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max');


commit;



-- ######################### CASE 1 ############################### --
--TEST: create triggers
create trigger trigg1 before update on t2 execute insert into t2 values ((select max(id) from t2) + 1, 'updated');
create trigger trigg2 after insert on t2 execute insert into t1 values((select max(id) from t1) + 1, 'inserted');
create trigger trigg3 after delete on t2 execute insert into t1 values((select max(id) from t1) + 1, 'deleted');


--TEST: merge table with pk into table with fk
merge into t2
using t1
on (t1.id=t2.id)
when matched then
update
set t2.name=t1.phone
where t2.id < 3
delete where t2.id=2;

--TEST: check update result
select if(count(*)=2, 'ok', 'nok') from t1 where phone='inserted';
select if(count(*)=2, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=1, 'ok', 'nok') from t1 where phone='deleted';
select * from t1 order by 1;
select * from t2 order by 1;

rollback;


-- ######################### CASE 2 ############################### --
--TEST: create triggers
create trigger trigg1 before update on t2 execute insert into t2 values ((select max(id) from t2) + 1, 'updated');
create trigger trigg2 after insert on t2 execute insert into t1 values((select max(id) from t1) + 1, 'inserted');
create trigger trigg3 after delete on t2 execute delete from t1 where id=1;


--TEST: [er] error in delete trigger action
merge into t2
using t1
on (t1.id=t2.id)
when matched then
update
set t2.name=t1.phone
where t2.id < 3
delete where t2.id=2;

--TEST: check update result
select if(count(*)=0, 'ok', 'nok') from t1 where phone='inserted';
select if(count(*)=0, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=0, 'ok', 'nok') from t2 where name='deleted';
select * from t1 order by 1;
select * from t2 order by 1;

rollback;


-- ######################### CASE 3 ############################### --
--TEST: create triggers
create trigger trigg1 before update on t2 execute insert into t2 values ((select max(id) from t2) + 1, 'updated');
create trigger trigg2 after insert on t2 execute delete from t1 where id=1;
create trigger trigg3 after delete on t2 execute insert into t1 values((select max(id) from t1) + 1, 'deleted');


--TEST: [er] error in insert trigger action
merge into t2
using t1
on (t1.id=t2.id)
when matched then
update
set t2.name=t1.phone
where t2.id < 3
delete where t2.id=2
when not matched then
insert
values(t1.id, t1.phone);

--TEST: check update result
select if(count(*)=0, 'ok', 'nok') from t2 where name='updated';
select if(count(*)=0, 'ok', 'nok') from t2 where name='deleted';
select * from t1 order by 1;
select * from t2 order by 1;

rollback;




-- ######################### CASE 4 ############################### --
create table trigger_actions(id smallint auto_increment, info varchar);

create trigger trigg1 before update on t2 execute insert into trigger_actions(info) values ('updated');
create trigger trigg2 after insert on t2 execute insert into trigger_actions(info) values ('inserted');
create trigger trigg3 before delete on t2 execute insert into trigger_actions(info) values ('deleted');


--TEST: error, foreign key constraint error in delete clause
merge into t1
using t2
on (t1.id=t2.id)
when matched then
update
set t1.phone=t2.name
where t1.id > 0 and t2.id < 10
delete where t1.id=2
when not matched then
insert
values(t2.id, t2.name);

--TEST: check the result
select * from t2;
select if(count(*)=0, 'ok', 'nok') from t2 where name in ('aaa', 'bbb');
select if(count(*)=0, 'ok', 'nok') from trigger_actions;


--TEST: error, foreign key constraint error in insert clause
merge into t2
using t1
on (t2.id=t1.id)
when matched then
update
set t2.name=t1.phone
delete where t2.id > 2
when not matched then
insert
values(t1.id+1, t1.phone);

--TEST: check the result
select * from t2;
select if(count(*)=3, 'ok', 'nok') from t2;
select if(count(*)=0, 'ok', 'nok') from t2 where name in (select phone from t1);
select if(count(*)=0, 'ok', 'nok') from trigger_actions;


rollback;



drop table t2, t1;
commit;



autocommit on;
