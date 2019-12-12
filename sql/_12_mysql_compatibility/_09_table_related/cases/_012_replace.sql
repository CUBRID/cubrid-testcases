create table tree(id int primary key, parentid int default 4, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAA');
insert into tree values(8,3,'AAB');

insert into tree
	values(3,default,'-AA');

replace into tree
	values(3,default,'-AA');

replace into tree
	select id,4,text
		from tree
		where id in (7,8);

select *
	from tree
	order by id;

drop table tree;