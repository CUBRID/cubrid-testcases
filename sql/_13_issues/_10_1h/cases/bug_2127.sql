create table foo (a int, b int, c int);
create index idx_a on foo(a);
create index idx_b on foo(b);
insert into foo values (1, 1, 1);
insert into foo values (2, 2, 2);

create table bar(a int, b int);
create index idx_ab on bar(a, b);
create index idx_a on bar (a);
insert into bar values(1, NULL);

select count(*) 
FROM foo A 
JOIN foo B ON A.c = B.a
JOIN (select bar.a, bar.b from bar bar where a=1) rcnt_bar ON (a.b = rcnt_bar.a or a.b = rcnt_bar.b);

drop table foo;
drop table bar;

