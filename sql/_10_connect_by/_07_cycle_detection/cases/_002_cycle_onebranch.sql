create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,5,'A');
insert into tree values(2,1,'B');
insert into tree values(3,2,'C');
insert into tree values(4,3,'D');
insert into tree values(5,4,'E');
insert into tree values(6,1,'F');
insert into tree values(7,6,'G');

select id,parentid,text
	from tree
	start with text='A'
	connect by prior id=parentid
	order by id;
	
select id,parentid,text,connect_by_iscycle
	from tree
	start with text='A'
	connect by nocycle prior id=parentid
	order by id;
	
drop table tree;