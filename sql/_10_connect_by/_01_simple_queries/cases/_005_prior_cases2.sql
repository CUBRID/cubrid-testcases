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
	start with text='A'
	connect by -parentid=prior (-id) or parentid=prior(-id)
	order by id;
	
select id,parentid,text
	from tree
	start with text='A'
	connect by -parentid=prior (-id) or prior(-id)=parentid
	order by id;

select id,parentid,text,level
	from tree
	start with text='A'
	connect by parentid=prior id and 9999>prior id
	order by id;

select id,parentid,text
	from tree
	where text<>'B' and length(text)=1
	start with text='A'
	connect by nocycle -parentid=prior (-id) or 9999>prior id
	order by id;

select id,parentid,text
	from tree
	start with text='A'
	connect by prior (-id)=-parentid
	order by id;

select id,parentid,text
	from tree
	start with text='A'
	connect by prior (-id)=999 or 999=prior(-id)
	order by id;
	
drop table tree;