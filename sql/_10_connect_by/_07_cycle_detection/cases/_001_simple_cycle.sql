create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,11,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,3,'AAA');
insert into tree values(6,3,'AAB');
insert into tree values(7,4,'ABA');
insert into tree values(8,4,'ABB');
insert into tree values(9,2,'BA');
insert into tree values(10,9,'BAA');
insert into tree values(11,10,'BAAA');

select id,parentid,text
	from tree
	start with text in ('A','B')
	connect by prior id=parentid
	order by id;
	
select id,parentid,text,connect_by_iscycle
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	order by id;
	
drop table tree;