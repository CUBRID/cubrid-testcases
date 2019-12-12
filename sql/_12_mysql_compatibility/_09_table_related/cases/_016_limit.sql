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

select *
	from tree
	order by 1, 2, 3
	limit 4,10;
	
select *
	from tree
        order by 1, 2, 3
	limit 5,18446744073709551615;
	
select *
	from tree
	order by 1, 2, 3
	limit 5;

drop table tree;
