--TEST: Statement insert trigger event will be triggered when there is no insert execution in a merge statement.


create table target(a int, b char(10));
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');

create table source(a int, b varchar, c int);
insert into source values(1, 'aaa', 1);
insert into source values(2, 'bbb', 1);

create table trigger_actions1(id smallint auto_increment, info varchar);
create trigger trigg1 before statement update on target execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after statement insert on target execute insert into trigger_actions1(info) values ('inserted');


merge into target t
using source s
on (t.a=s.a)
when matched then
update 
set t.b='updated'
when not matched then
insert(t.a, t.b)
values(s.a, 'inserted');

select * from target order by 1;
select * from trigger_actions1 order by 1;


drop trigger trigg1, trigg2;
drop table source, target, trigger_actions1;
