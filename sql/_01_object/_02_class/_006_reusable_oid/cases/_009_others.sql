create table foo(id int unique) reuse_oid;

commit;

insert into foo values (1);
insert into foo values (2);
insert into foo values (3);

select *
	from foo;
	
insert into foo values (9)
	on duplicate key update id = 5;

select *
	from foo;

insert into foo values (9)
	on duplicate key update id = 5;

select *
	from foo;

drop table foo;
