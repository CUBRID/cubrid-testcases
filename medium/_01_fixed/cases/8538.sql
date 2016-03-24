autocommit off;
create class foo(f numeric(4,2));
insert into foo values(20.00);
insert into foo values(40.00);
insert into foo values(60.00);
select sum(f) from foo;
select avg(f) from foo;
rollback;
