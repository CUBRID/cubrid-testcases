create table foo(id int);

drop table foo;

create table foo(id int) reuse_oid, reuseoid;

drop table foo;

create table foo(id int) reuse_oid;

commit;

select class_name, flags
	from _db_class
	where class_name='foo';
	
drop table foo;
