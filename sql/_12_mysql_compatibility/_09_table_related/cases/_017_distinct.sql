create table tree(g1 int,g2 int,g3 int,text varchar(32))

insert into tree values(1,1,1,'a');
insert into tree values(1,1,2,'a');
insert into tree values(1,2,1,'a');
insert into tree values(1,2,2,'a');
insert into tree values(1,2,3,'a');
insert into tree values(1,3,1,'a');
insert into tree values(1,3,2,'a');
insert into tree values(1,3,3,'a');
insert into tree values(2,1,1,'a');
insert into tree values(2,1,2,'a');
insert into tree values(2,2,1,'a');
insert into tree values(2,2,2,'a');
insert into tree values(2,3,1,'a');
insert into tree values(2,3,2,'a');
insert into tree values(3,1,1,'a');
insert into tree values(3,1,2,'a');
insert into tree values(3,2,1,'a');
insert into tree values(3,2,2,'a');
insert into tree values(3,3,1,'a');
insert into tree values(3,3,2,'a');

select distinct g1,g2,g3
	from tree
	order by g1,g2,g3;
	
select distinctrow g1,g2,g3
	from tree
	order by g1,g2,g3;

drop table tree;