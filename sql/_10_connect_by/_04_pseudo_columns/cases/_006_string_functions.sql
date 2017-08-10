create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,sys_connect_by_path(text,'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;
	
select id,sys_connect_by_path('-'+text+'-','/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,sys_connect_by_path(cast(id as varchar),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,sys_connect_by_path(concat('a', 'b'),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,sys_connect_by_path(substr(text,1,32),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;
	
select id,sys_connect_by_path(concat(cast(id as varchar),text),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,sys_connect_by_path(substr(text || text,1,32),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,sys_connect_by_path(concat(text,text),'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

drop table tree;