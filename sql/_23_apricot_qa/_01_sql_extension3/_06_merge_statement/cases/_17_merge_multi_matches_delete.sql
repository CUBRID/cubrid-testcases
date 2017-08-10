--multiple matched rows in the target table, with delete clasue


autocommit off;


create table target(a int, b char(10));
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');
insert into target values(2, 'ccc');
insert into target values(2, 'ddd');
insert into target values(2, 'eee');
insert into target values(2, 'fff');

create table source(a int, b varchar, c int);
insert into source values(1, 'aaa', 1);
insert into source values(2, 'updated', 1);
insert into source values(3, 'inserted', 2);

commit;

--TEST: update and delete, 3 rows deleted.
merge into target t
using source s
on (t.a=s.a)
when matched then
update 
set t.b=s.b
where t.b < 'ddd'
delete where 1 > 0;

select if (count(*)=0, 'ok', 'nok') from target where b='updated';
select if (count(*)=3, 'ok', 'nok') from target;
rollback;


--TEST: update, delete and insert
merge into target t
using source s
on (t.a=s.a)
when matched then
update
set t.b=s.b
where t.b < 'ddd'
delete where t.b='updated'
when not matched then
insert(t.a, t.b)
values(s.a, s.b);

select if (count(*)=0, 'ok', 'nok') from target where b='updated';
select if (count(*)=1, 'ok', 'nok') from target where b='inserted';
select if (count(*)=5, 'ok', 'nok') from target;

drop table target, source;
commit;




create table target(a int, b char(10) unique);
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');
insert into target values(2, 'ccc');
insert into target values(2, 'ddd');
insert into target values(2, 'eee');
insert into target values(2, 'fff');

create table source(a int, b varchar, c int);
insert into source values(1, 'aaa', 1);
insert into source values(2, 'updated', 1);
insert into source values(3, 'inserted', 2);

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on target execute insert into trigger_actions(info) values ('updated');
create trigger trigg2 after insert on target execute insert into trigger_actions(info) values ('inserted');
create trigger trigg3 after delete on target execute insert into trigger_actions(info) values ('deleted');


--TEST: error, update and insert, unique violation.
merge into target t
using source s
on (t.a=s.a)
when matched then
update 
set t.b=s.b
delete where s.a < 2
when not matched then
insert(a, b)
values(s.a, 'inserted');

select if (count(*)=6, 'ok', 'nok') from target;
select if (count(*)=0, 'ok', 'nok') from target where b='updated';
select if (count(*)=0, 'ok', 'nok') from trigger_actions;


drop trigger trigg1, trigg2;
drop table target, source, trigger_actions;
commit;





autocommit on;
