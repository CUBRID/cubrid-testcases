create table foo(id int,text varchar(32));

commit;

insert into foo values(1,'1');
insert into foo values(2,'2');
insert into foo values(3,'3');
insert into foo values(4,'4');
insert into foo values(5,'5');
insert into foo values(6,'6');

select *
	from foo order by 1;
	
create table foo2(id int) reuse_oid as 
	select id 
		from foo order by 1;
		
drop table foo;

select *
	from foo2 order by 1;
	
delete from foo2 
	where id between 2 and 4;

commit;

insert into foo2 values(7);
insert into foo2 values(8);
insert into foo2 values(9);
insert into foo2 values(10);

select *
	from foo2 order by 1;

drop table foo2;
