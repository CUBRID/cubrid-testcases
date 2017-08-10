--TEST: [Merge Statement] No error occurs when inserting into the source table in a merge statement.

create table target(a smallint, b char(10));
insert into target values(100, 'aaa');

create table source(a int, b char(10));
insert into source values(200, 'hhh');

--error expected
merge into target t
using source s
on (t.a=s.a)
when not matched then
insert(s.a, s.b)
values(s.a, 'inserted');


drop table target, source;
