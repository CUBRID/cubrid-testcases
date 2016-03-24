create table foo(a int, b int);
insert into foo values(1, 10), (2, 20), (1, 10), (1, 40), (2, 30);
select group_concat(a, b) from foo;
select group_concat() from foo;
select group_concat(a, b, a) from foo;

drop table foo;
