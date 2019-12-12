create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select *
	from tree
	connect by id=parentid
	order by id;
	
select *
	from tree
	connect by id
	order by id;

select *
	from tree
	connect by prior id
	order by id;

select *
	from tree
	start with parentid
	connect by prior id=parentid
	order by id;

select parentid,count(*) "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by parentid;
	
select parentid,count(*) "count"
	from tree
	connect by prior id
	group by parentid
	order by parentid;
	
select parentid,count(*) "count"
	from tree
	connect by id=parentid
	group by parentid
	order by parentid;

drop table tree;