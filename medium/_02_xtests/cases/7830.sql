autocommit off;
create class foo (i int);
create class bar (fs set of foo);
create trigger foo_upd_trig
	before update on foo
	execute reject;
create trigger bar_del_trig
	priority 2.0
	before delete on bar
	if 0 < (select count(y) from table(obj.fs) t(y) where y is not null)
	execute reject;
insert into foo values (13) to :f;
insert into bar values ({:f}) to :b;
delete from foo;
delete from bar;
select count(*) from bar;
rollback;
