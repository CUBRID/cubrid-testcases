create table tree(id int,parentid int,text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,null,'C');
insert into tree values(4,1,'AA');
insert into tree values(5,1,'AB');
insert into tree values(6,2,'BA');
insert into tree values(7,2,'BB');
insert into tree values(8,2,'BC');

select parentid,bit_and(id) as [bit_and]
	from tree
	group by parentid;
	
select parentid,bit_and(parentid) as [bit_and]
	from tree
	group by parentid;
	
select parentid,bit_and(text) as [bit_and]
	from tree
	group by parentid;
	
select parentid,bit_and(parentid) as [bit_and]
	from tree
	where id<4
	group by parentid;

drop table tree;