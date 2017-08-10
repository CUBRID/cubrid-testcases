create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select * from tree order by id;

select *
	from tree
	connect by prior id=parentid
	order by id;
	
select *
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select *
	from tree
	where text like '%A'
	start with parentid is null
	connect by prior id=parentid
	order by id;
	
select parentid,count(*) "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by parentid
	order by parentid;
	
select parentid,count(*) "count"
	from tree
	start with parentid is null
	connect by prior id=parentid
	group by parentid
	having count(*)>1
	order by parentid;
	
select parentid,count(*) "count"
	from tree
	connect by prior id=parentid
	group by parentid
	order by parentid;
	
select parentid,count(*) "count"
	from tree
	connect by prior id=parentid
	group by parentid
	having count(*)>1
	order by parentid;

select *
	from tree
	start with text in ('BBA','BA','AA','AB')
	connect by prior parentid=id
	order by id;

drop table tree;