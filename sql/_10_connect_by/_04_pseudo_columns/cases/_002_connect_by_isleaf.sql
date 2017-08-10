create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,connect_by_isleaf
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,connect_by_isleaf
	from tree
	where connect_by_isleaf=1
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,connect_by_isleaf
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by connect_by_isleaf,id;
	
select connect_by_isleaf,count(*) "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by connect_by_isleaf
	order by connect_by_isleaf;

select parentid,sum(connect_by_isleaf) "sum"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by parentid
	having sum(connect_by_isleaf)>1;

drop table tree;