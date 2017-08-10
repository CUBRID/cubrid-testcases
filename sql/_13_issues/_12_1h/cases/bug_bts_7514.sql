--TEST:  [Merge Statement] merge_update_clause execution is skipped and merge_insert_clause is executed successfully when an error occurred in the 'before update' trigger action.


create table target(a int, b int, c char(10));
insert into target values(1, 10, 'aaa');
insert into target values(2, 22, 'bbb');

create table source(a int, b int, c varchar);
insert into source values(1, 10, 'UPDATE');
insert into source values(2, 10, 'UPDATE');
insert into source values(3, 10, 'INSERT');

create table trigger_action(a int unique);
create trigger bef_upd before update on target execute insert into trigger_action values(1);

--[er]
merge into target t
using source s
on s.a=t.a
when matched then
update
set t.c=s.c;

--[er]
merge into target t
using source s
on s.a=t.a
when matched then
update
set t.c=s.c
when not matched then
insert
values(3, 33, 'INSERT');

select * from target order by 1;
select if (count(*)=0, 'ok', 'nok') from trigger_action;

drop trigger bef_upd;
drop table target, source, trigger_action;


