create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,level
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;
	
select id,parentid,text,level
	from tree
	start with parentid is null and id between 1 and 100
	connect by prior id=parentid
	order by id;

select id,parentid,text,level
	from tree
	where text like '%A'
	start with parentid is null
	connect by prior id=parentid and (id>2 or parentid between 1 and 100) and length(prior text)<3
	order by id;
	
drop table tree;