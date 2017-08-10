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
	order by id;

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
  	start with parentid is null
	connect by prior id=parentid
	order by text for orderby_num() between 2 and 5 ;

drop table tree;