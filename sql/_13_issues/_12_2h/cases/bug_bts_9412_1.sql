--TEST: allow columns referenced in ON condition to be affected in a MERGE statement


autocommit off;

create table src(a int, b int, c varchar, d string, e int);
create table dst(a int, b int, c varchar, d string, e int);

insert into src values(1, 100, 'a', 'aa', 11);
insert into src values(2, 200, 'b', 'bb', 22);
insert into src values(3, 300, 'c', 'bb', 33);
insert into src values(4, 400, 'c', 'cc', 44);

insert into dst values(1, 1, 'c', 'gg', 22);
insert into dst values(2, 2, 'e', 'bb', 33);
insert into dst values(3, 3, 'g', 'aa', 55);

commit;

merge into dst t
using (select * from src where b < 500 and e > 20) s
on (t.a=s.a and (t.b != s.b or t.c != s.c or t.d != s.d or t.e != s.e))
when matched then
update set t.a=s.a, t.b=s.b, t.c=s.c, t.d=s.d, t.e=s.e;

select * from dst order by a;

rollback;

merge into dst t
using (select * from src where b < 500 and e > 20) s
on (t.a=s.a and (t.b != s.b or t.c != s.c or t.d != s.d or t.e != s.e))
when matched then
update set t.a=s.a, t.b=s.b, t.c=s.c, t.d=s.d, t.e=s.e
when not matched then
insert values(s.a, s.b, s.c, s.d, s.e);

select * from dst order by a;

drop table dst, src;

commit;

autocommit on;
