autocommit off;
create class foo (a string unique);
create class bar (b int, fooptr1 foo, fooptr2 foo);
insert into foo values ('1');
insert into bar values (1, (insert into foo values('2')),
			   (insert into foo values('3')));
insert into bar values (4, (insert into foo values ('4')), 
			   (insert into foo values ('1')));
select * from foo;
insert into bar values (5, (insert into foo values ('1')), 
			   (insert into foo values ('5')));
select * from foo;
select * from bar;
select b, fooptr1.a, fooptr2.a from bar;
rollback;
