create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,level,connect_by_isleaf
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,level,connect_by_isleaf
	from tree
	where level=2
		and connect_by_isleaf=1
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,level,connect_by_isleaf
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by level desc,id;

update tree set parentid=7 where id=2;

select id,parentid,text,level,connect_by_isleaf,connect_by_iscycle
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	order by id;

drop table tree;