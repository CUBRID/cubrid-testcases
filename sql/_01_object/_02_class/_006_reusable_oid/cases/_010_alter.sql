create table foo(id int) reuse_oid;

commit;

insert into foo values (1);
insert into foo values (2);
insert into foo values (3);

select *
	from foo order by 1;
	
alter table foo add column text varchar(32);

select *
	from foo order by 1;

update foo set text='A' where id=1;
update foo set text='B' where id=2;
update foo set text='C' where id=3;

select *
	from foo order by 1;

insert into foo values(4,'D');

select *
	from foo order by 1;

drop table foo;
