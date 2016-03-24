create table foo(id int unique) reuse_oid
	partition by list (id)(
					partition p0 values in (1,2,3),
					partition p1 values in (4,5,6),
					partition p2 values in (7,8,9)
				);

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
