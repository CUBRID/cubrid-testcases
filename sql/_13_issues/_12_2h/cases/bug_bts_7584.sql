--TEST: [Merge Statement] Result is incorrect when merging into a table using a subquery.

autocommit off;

drop table if exists target;
drop table if exists source;

create table target(a int, b clob);
insert into target values(1, 'aaa');
insert into target values(2, 'bbb');
insert into target values(3, 'eee');

create table source(a int, b char(10));
insert into source values(11, 'aaa');
insert into source values(22, 'bbb');
insert into source values(33, 'ccc');
insert into source values(44, 'DDD');

commit;

merge into target t
using (select * from source) s
on clob_to_char(t.b)=s.b
when matched then
update 
set t.a=s.a;

select if(count(*)=2, 'ok', 'nok') from target where a in(11, 22);

rollback;

merge into target t
using source s
on clob_to_char(t.b)=s.b
when matched then
update 
set t.a=s.a;

select if(count(*)=2, 'ok', 'nok') from target where a in(11, 22);

rollback;

merge into target t
using (select * from source) s
on clob_to_char(t.b)=s.b
when matched then
update set t.a=s.a
when not matched then
insert values(s.a, s.b);

select if(count(*)=2, 'ok', 'nok') from target where a in(33, 44);


delete from target;
drop target, source;

commit;


autocommit on;
