create table foo(id int) reuse_oid;

commit;

insert into foo values (1);
insert into foo values (2);
insert into foo values (3);

select *
	from foo;
	
alter table foo add column text varchar(32);

select *
	from foo;

update foo set text='A' where id=1;
update foo set text='B' where id=2;
update foo set text='C' where id=3;

select *
	from foo;

alter table foo drop column id;

insert into foo values('D');
insert into foo values('D');
insert into foo values('D');
insert into foo values('D');
insert into foo values('D');
insert into foo values('D');

select *
	from foo;

create class xoo ( a int);
alter table xoo add column foo foo;

drop table foo;
drop table xoo;
