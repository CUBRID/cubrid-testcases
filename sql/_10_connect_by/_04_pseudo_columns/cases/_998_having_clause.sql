create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select level,count(*) as "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by level
	having level=2;

select connect_by_isleaf,count(*) as "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by connect_by_isleaf
	having connect_by_isleaf=1;

update tree set parentid=7 where id=2;

select connect_by_iscycle,count(*) as "count"
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	group by connect_by_iscycle
	having connect_by_iscycle=1;

drop table tree;