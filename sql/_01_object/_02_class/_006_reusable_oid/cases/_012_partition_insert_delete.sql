create table foo(id int) reuse_oid
	partition by list (id)(
					partition p0 values in (1,2,3),
					partition p1 values in (4,5,6),
					partition p2 values in (7,8,9)
				);

commit;

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(5);
insert into foo values(6);

select *
	from foo order by id;
	
insert into foo values(7);
delete from foo where id=2;
delete from foo where id=3;
insert into foo values(8);

select *
	from foo order by id;
	
insert into foo values(9);

select *
	from foo order by id;

drop table foo;
