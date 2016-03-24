create table foo(id int)
	partition by list (id)(partition p0 values in (1,2,3));

drop table foo;

create table foo(id int) reuse_oid
	partition by list (id)(partition p0 values in (1,2,3));;

commit;

select class_name, is_system_class
	from _db_class
	where class_name='foo';
	
drop table foo;
