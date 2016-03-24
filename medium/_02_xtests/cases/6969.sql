autocommit off;
create class foo ( id int UNIQUE)
	method class set_cost(string, string) string function qo_set_cost;
insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(5);
call set_cost('iscan', '0') on class foo;
--set optimization: level 257;
select * from foo where id >= 1;
select * from foo where 1 <= id;
rollback;
