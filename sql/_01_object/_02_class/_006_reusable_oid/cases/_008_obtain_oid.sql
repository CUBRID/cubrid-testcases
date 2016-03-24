create table foo(id int) reuse_oid;

commit;

insert into foo values(1);
insert into foo values(2);

insert into foo values(3) :x;

create table a(o_id object);

insert into a values(insert into foo values(4));

insert into a
	select foo
		from foo;
		
drop table a;

create table a(o_id set of object);

insert into a values({insert into foo values(5)});

drop table a;

select foo
	from foo;
	
drop table foo;