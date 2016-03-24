autocommit off;
create class foo ( m int);
create trigger foo_trigger
	before update on foo(m)
	execute print 'foo(m) trigger';
rollback work;
rollback;
