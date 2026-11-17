autocommit off;

create class foo (a string);
create class bar (b int unique, fooptr foo);
insert into foo values ('1') into :foo1;
insert into bar(b) values (11);
insert into bar values (12, :foo1);
insert into bar values (13, (insert into foo values ('3')));
insert into bar(b) values (14);
insert into bar(fooptr) values ((insert into foo values('4')));
insert into bar(fooptr) values ((insert into foo values('5')));
insert into bar values (14, (insert into foo values ('1')));
insert into bar(fooptr) values ((insert into foo values ('3')));
select * from foo order by a;
select * from bar order by b nulls last, fooptr.a nulls last;
select b, fooptr.a from bar order by b nulls last, fooptr.a nulls last;
rollback;
