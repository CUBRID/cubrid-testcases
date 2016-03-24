autocommit off;
create class baz (c int);
insert into baz values (16) into :p0;
create class bar (b int, c1 baz);
insert into bar values (1, :p0) into :p2;
create class foo class attribute (ca1 hotel, b1 bar) (a int, b2 bar);
insert into foo values (14, p2);
update class foo set ca1 = (select hotel from hotel where name = 'Ambiance'),
		     b1 = p2;
select class foo.ca1.name from foo;
select foo into :p1 from foo;
select p1.a, foo.a from foo;
select class foo.b1.c1.c, class foo.b1.b from foo; -- try two levels
select p1, foo.a from foo; -- make sure we can still grab just a param
select :p1.a, foo.a from foo; -- need to allow both kinds of syntax
select :p1.b2.c1.c, :p1.b2.b from foo; -- try two levels, other syntax
select a into :c from foo;
select c, :c from baz;
create class x(a int);
select 2 into :a from class db_user;
insert into x values(1);
select 'ok' from x
	where a = (select a from class db_user);
select 'ok' from x
	where a <> (select :a from class db_user);
drop baz, foo, x, bar;
rollback;
