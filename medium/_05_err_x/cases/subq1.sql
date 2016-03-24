autocommit off;

create class foo1 (b int);
create class bar (c int);
insert into foo1(b) values(4);
insert into bar(c) values(1);
insert into bar(c) values(2);
select b, (select c from bar) from foo1;
rollback;
