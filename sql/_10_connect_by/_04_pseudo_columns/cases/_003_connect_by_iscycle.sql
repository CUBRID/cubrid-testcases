create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,7,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,connect_by_iscycle
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	order by id;

select id,parentid,text,connect_by_iscycle
	from tree
	where connect_by_isleaf=1
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	order by id;

select id,parentid,text,connect_by_iscycle
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	order by connect_by_iscycle,id;
	
select connect_by_iscycle,count(*) "count"
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	group by connect_by_iscycle
	order by connect_by_iscycle;

select parentid,sum(connect_by_iscycle) "sum"
	from tree
	start with text in ('A','B')
	connect by nocycle prior id=parentid
	group by parentid
	having sum(connect_by_iscycle)>-1;

drop table tree;