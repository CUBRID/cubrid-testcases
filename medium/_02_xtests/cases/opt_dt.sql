autocommit off;
create class foo (n int,
		  f set of foo)
	method class set_cost(string, string) function qo_set_cost;
insert into foo values (1, {}) to :foo1;
insert into foo values (2, {:foo1});
create index i_foo_n on foo(n);
call set_cost('iscan', '0') on class foo;
--set optimization: level 257;
select count(*) from foo;
select n from foo where n = 2;
select n from foo, table(foo.f) as t(c) where n = 2;
select c.n from foo, table(foo.f) as t(c) where n = 2;
rollback;
