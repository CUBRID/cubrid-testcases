create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text
	from tree
	where prior id=6 and prior id=6
	start with parentid is null
	connect by parentid=prior id
	order by id;
		
select id,parentid,text
	from tree
	where prior id is null
	start with parentid is null
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where prior id is null and prior id is not null
	start with parentid is null
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where prior id>=2 and prior id<=6
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where prior text like 'A%'
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where (prior id>=2 and prior id<=6) and (prior id>=50 and prior id<=100)
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where prior id=1 and prior id<=20
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select id,parentid,text
	from tree
	where prior id<=20 and prior id>=10 and prior id<=200 and prior id>=0
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select tree.*,prior 1 as "col1"
	from tree
	start with parentid is null 
	connect by parentid=prior id
	order by id;

select tree.*,prior id as "col1"
	from tree;

drop table tree;