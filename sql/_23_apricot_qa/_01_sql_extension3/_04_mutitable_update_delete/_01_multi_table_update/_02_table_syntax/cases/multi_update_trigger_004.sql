-- trigger actions in 3 table update

autocommit off;

--create tables with trigger
create table trigg1(id int, str char(10));
insert into trigg1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd');

create table trigg2(id smallint, str char(20));
insert into trigg2 values(2, 'eee'), (4, 'fff'), (6, 'ggg'), (8, 'hhh');

create table trigg3(id smallint auto_increment, str char(20));
insert into trigg3(str) values('iii'), ('jjj'), ('kkk'), ('lll');


--create triggers
create trigger u1 before update on trigg1
execute insert into trigg2 values (100, 'inserted2');

create trigger u2 after update on trigg2
execute insert into trigg3(str) values ('inserted3');

create trigger u3 after update on trigg3
execute insert into trigg1 values (100, 'inserted1');

commit;


select * from trigg1 order by 1;
select * from trigg2 order by 1;
select * from trigg3 order by 1;



--TEST: update 3 tables and rollback
update trigg1 t1 inner join trigg2 t2 on t1.id=t2.id right outer join trigg3 t3 on t1.id=t3.id set t1.id=t2.id+3, t2.str=trim(t1.str)+'abc', t3.str=t2.str;
--TEST: check update result before rollback
select if (id in (5, 7), 'ok', 'nok') from trigg1 where str in ('bbb', 'ddd');
select if (count(*) = 2, 'ok', 'nok') from trigg2 where trim(str) in ('bbbabc', 'dddabc');
select case when count(*)=2 then 'ok' else 'nok' end from trigg3 where str is null;
--TEST: check trigger action before rollback
select if (count(*) = 4, 'ok', 'nok') from trigg1 where str='inserted1';
select if (count(*) = 2, 'ok', 'nok') from trigg2 where str='inserted2';
select if (count(*) = 2, 'ok', 'nok') from trigg3 where str='inserted3';
--rollback
rollback;
--TEST: check update result after rollback
select if (id in (1, 2, 3, 4), 'ok', 'nok') from trigg1;
select if (str = 'updated1', 'nok', 'ok') from trigg2;
select case when count(*)=0 then 'ok' else 'nok' end from trigg3 where str is null;
--TEST: check trigger action after rollback
select if (count(*) = 0, 'ok', 'nok') from trigg1 where str='inserted1';
select if (count(*) = 0, 'ok', 'nok') from trigg2 where str='inserted2';
select if (count(*) = 0, 'ok', 'nok') from trigg3 where str='inserted3';



drop trigger u1, u2, u3;
drop table trigg1, trigg2, trigg3;

commit;
autocommit on;






