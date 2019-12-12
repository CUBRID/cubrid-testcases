--TEST: [Merge Statement] Result is inconsistent with Oracle when using inequality as the merge condition.


drop table if exists target, source, trigger_actions;

create table target(a int, b char(10));
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');
insert into target values(3, 'ccc');

create table source(a int, b varchar(10));
insert into source values(1, 'AAA');
insert into source values(2, 'BBB');
insert into source values(3, 'CCC');
insert into source values(4, 'DDD');
insert into source values(5, 'EEE');
insert into source values(6, 'FFF');

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on target execute insert into trigger_actions(info) values ('updated');
create trigger trigg2 after insert on target execute insert into trigger_actions(info) values ('inserted');

--error should occur
merge into target t
using source s
on (s.a > t.a)
when matched then
update 
set t.b=s.b
when not matched then
insert(t.a, t.b)
values(s.a, s.b);

select * from target order by 1;
select * from trigger_actions order by 1;

drop table target, source, trigger_actions;


--server side
create table target(a int, b char(10));
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');
insert into target values(3, 'ccc');

create table source(a int, b varchar(10));
insert into source values(1, 'AAA');
insert into source values(2, 'BBB');
insert into source values(3, 'CCC');
insert into source values(4, 'DDD');
insert into source values(5, 'EEE');
insert into source values(6, 'FFF');

merge into target t
using source s
on (s.a > t.a)
when matched then
update 
set t.b=s.b
when not matched then
insert(t.a, t.b)
values(s.a, s.b);

merge into target t
using source s
on (s.a <= t.a)
when matched then
update
set t.b=s.b
when not matched then
insert(t.a, t.b)
values(s.a, s.b);

select * from target order by 1;

drop table target, source;
