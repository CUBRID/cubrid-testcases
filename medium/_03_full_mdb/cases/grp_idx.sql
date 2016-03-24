autocommit off;
create class foo (x int, y int);
insert into foo values (1, 10);
insert into foo select x, y from foo; --2
insert into foo select x, y from foo; --4
insert into foo select x, y from foo; --8
insert into foo select x, y from foo; --16
insert into foo select x, y from foo; --32
insert into foo select x, y from foo; --64
insert into foo select x, y from foo; --128
insert into foo select x, y from foo; --256
insert into foo select x, y from foo; --512
create index i_foo_x on foo(x);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select count(*) from foo a, foo b 
where a.x = 1 and b.y = 10;
select count(*) from foo a, foo b
where a.y = 10 and b.x = 1
select count(*) from foo a, foo b
where a.x = 1 and b.x = 1;
--set optimization: level 0;
select count(*) from foo a, foo b 
where a.x = 1 and b.y = 10;
drop foo;
rollback;
