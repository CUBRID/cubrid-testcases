autocommit off;
create class foo ( a int);
create trigger foo_trigger
	deferred update on foo
	if old.n = 100
		execute print 'foo_trigger';
rollback work;
rollback;
