create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,3,'A1');
insert into tree values(2,1,'B1');
insert into tree values(3,2,'C1');
insert into tree values(4,6,'A2');
insert into tree values(5,4,'B2');
insert into tree values(6,5,'C2');

select id,parentid,text
	from tree
	start with text in ('A1','A2')
	connect by prior id=parentid
	order by id;
	
select id,parentid,text,connect_by_iscycle
	from tree
	start with text in ('A1','A2')
	connect by nocycle prior id=parentid
	order by id;
	
drop table tree;