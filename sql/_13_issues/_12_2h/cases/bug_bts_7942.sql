--TEST: [Merge Statement] Number of affected rows is not correct in a merge statement with delete clause.


autocommit off;

drop table if exists target, source;

create table target(a int, b char(10), c int);
insert into target values(1, 'aaa', 11);
insert into target values(2, 'bbb', 22);
insert into target values(3, 'ccc', 33);
insert into target values(4, 'ccc', 33);

create table source(a int, b char(10), c int);
insert into source values(1, 'aaa', 11);
insert into source values(2, 'bbb', 22);
insert into source values(3, 'ccc', 33);
insert into source values(5, 'eee', 55);

commit;

merge into target t
using source s
on (t.a=s.a)
when matched then
update set t.b=s.b
delete where t.a < 5;

select if (count(*)=1, 'ok', 'nok') from target;
rollback;


merge into target t
using source s
on (t.a=s.a)
when matched then
update set t.b=s.b
delete where t.a < 5
when not matched then
insert values(s.a, s.b, s.c);

select if (count(*)=2, 'ok', 'nok') from target;

drop table source, target;

commit;
autocommit on;

