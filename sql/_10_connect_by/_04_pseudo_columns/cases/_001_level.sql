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
	where level=2
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,level
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by level desc,id;
	
select level,count(*) "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by level
	order by level;

select parentid,sum(level) "sum"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by parentid
	having sum(level)>2;
	
select sum(level) as "level"
	from tree
	start with parentid is null
	connect by prior id=parentid;

drop table tree;