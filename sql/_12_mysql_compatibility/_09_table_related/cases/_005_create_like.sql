create table tree(id int not null, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');

create table tree3 like tree2;

create table tree2 like tree;

insert into tree2
	select *
		from tree
		order by id;
		
select *
	from tree2
	order by id;
	
drop table tree;
drop table tree2;
drop table tree3;