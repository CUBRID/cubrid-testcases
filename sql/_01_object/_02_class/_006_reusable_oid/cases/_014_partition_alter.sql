create table foo(id int) reuse_oid
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
	from foo order by id;
	
alter table foo add column text varchar(32);

select *
	from foo order by id;

update foo set text='A' where id=1;
update foo set text='B' where id=2;
update foo set text='C' where id=3;

select *
	from foo order by id;

insert into foo values(4,'D');

select *
	from foo order by id;

drop table foo;
