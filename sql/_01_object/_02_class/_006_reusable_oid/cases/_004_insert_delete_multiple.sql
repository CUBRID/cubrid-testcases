create table foo(id int,text varchar(32)) reuse_oid;

commit;

insert into foo values(1,'1');
insert into foo values(2,'2');
insert into foo values(3,'3');
insert into foo values(4,'4');
insert into foo values(5,'5');
insert into foo values(6,'6');

select *
	from foo order by 1;
	
insert into foo values(7,'7');
delete from foo where text='2';
delete from foo where id=3;
commit;

insert into foo values(8,'8');

select *
	from foo order by 1;
	
insert into foo values(9,'9');
insert into foo values(10,'10');

select *
	from foo order by 1;

drop table foo;
