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
create trigger trigg1 before update on t2 execute insert into t2 values ((select max(id) from t2) + 1, 'inserted');
create trigger trigg2 after insert on t2 execute insert into t1 values((select max(id) from t1) + 1, 'inserted');


--TEST: merge table with pk into table with fk
merge into t2
using t1
on (t1.id=t2.id)
when matched then
update
set t2.name=t1.phone
where t2.id < 3;

--TEST: check update result
select if(count(*)=2, 'ok', 'nok') from t1 where phone='inserted';
select if(count(*)=2, 'ok', 'nok') from t2 where name='inserted';
select * from t1 order by 1;
select * from t2 order by 1;

rollback;



-- ######################### CASE 2 ############################### --

--create another table
create table t3(a int, b varchar(20));
insert into t3 values(1, 'aaa'), (2, 'bbb'), (5, 'George'), (8, 'ccc');

create table trigger_actions(id smallint auto_increment, info varchar);

create trigger trigg1 before update on t2 execute insert into trigger_actions(info) values ('updated');
create trigger trigg2 after insert on t2 execute insert into trigger_actions(info) values ('inserted');


--TEST: error, foreign key constraint error
merge into t2
using t3
on (t2.id=t3.a)
when matched then
update
set t2.name=t3.b
when not matched then
insert
values(t3.a, t3.b);

--TEST: check the result
select * from t2;
select if(count(*)=0, 'ok', 'nok') from t2 where name in ('aaa', 'bbb');
select if(count(*)=0, 'ok', 'nok') from trigger_actions;


update t3 set b='George' where a=2;
update t3 set b='Laura' where a=1;
--TEST: error, foreign key constraint error
merge into t2
using t3
on (t2.name=t3.b)
when matched then
update
set t2.id=t3.a
where t3.a=5
when not matched then
insert
values(t3.a, t3.b);

--TEST: check the result
select * from t2;
select if(count(*)=0, 'ok', 'nok') from t2 where name in ('aaa', 'bbb');
select if(count(*)=0, 'ok', 'nok') from trigger_actions;


rollback;



drop table t2, t1;
commit;



autocommit on;
