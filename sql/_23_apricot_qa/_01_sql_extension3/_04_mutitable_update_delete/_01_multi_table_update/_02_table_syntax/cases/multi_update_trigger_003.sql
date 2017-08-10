--autocommit off mode, trigger actions in multiple table update

autocommit off;


--create tables with trigger
create table trigg1(id int primary key, str char(10));
insert into trigg1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd');

create table trigg2(id smallint, str char(20) unique);
insert into trigg2 values(2, 'eee'), (4, 'fff'), (6, 'ggg'), (8, 'hhh');


--create trigger action tables
create table action1(id int primary key auto_increment, a char(20));
create table action2(id int primary key auto_increment, a char(20));

--create triggers
create trigger bef_upd before update on trigg1
execute insert into action1(a) values('BEFORE UPDATE');

create trigger aft_upd after update on trigg2
execute insert into action2(a) values('AFTER UPDATE');

commit;


select * from trigg1 order by 1;
select * from trigg2 order by 1;



--TEST: update 2 tables and rollback
update trigg1 t1 inner join trigg2 t2 on t1.id=t2.id set t1.id=t2.id+3, t2.str=trim(t1.str)+'abc';
--TEST: check update result before rollback
select if (id in (5, 7), 'ok', 'nok') from trigg1 where str in ('bbb', 'ddd');
select if (count(*) = 2, 'ok', 'nok') from trigg2 where trim(str) in ('bbbabc', 'dddabc');
--TEST: check trigger action before rollback
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 2, 'ok', 'nok') from action2;
--rollback
rollback;
--TEST: check update result after rollback
select if (id in (1, 2, 3, 4), 'ok', 'nok') from trigg1;
select if (str = 'updated1', 'nok', 'ok') from trigg2;
--TEST: check trigger action after rollback
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: error, duplicate key error during update
update trigg1 t1 inner join trigg2 t2 on t1.id=t2.id set t1.id=5, t2.str='updated2';
--commit
commit;
--TEST: check update result after rollback
select if (id in (1, 2, 3, 4), 'ok', 'nok') from trigg1;
select if (count(*) = 0, 'ok', 'nok') from trigg2 where str='updated2';
--TEST: check trigger action after rollback
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;



drop trigger bef_upd, aft_upd;
drop table trigg1, trigg2, action1, action2;
autocommit on;









