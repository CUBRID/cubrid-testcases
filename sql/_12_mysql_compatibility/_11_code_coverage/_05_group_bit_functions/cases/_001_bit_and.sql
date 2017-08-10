create table tree(id int,parentid int,sh short, text varchar(32));

insert into tree values(1,null,2,'A');
insert into tree values(2,null,3,'B');
insert into tree values(3,null,-1,'C');
insert into tree values(4,1,0,'AA');
insert into tree values(5,1,NULL,'AB');
insert into tree values(6,2,NULL,'BA');
insert into tree values(7,2,123,'BB');
insert into tree values(8,2,1,'BC');

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
	
select parentid,bit_and(sh) as [bit_and]
	from tree
	group by parentid;	

drop table tree;