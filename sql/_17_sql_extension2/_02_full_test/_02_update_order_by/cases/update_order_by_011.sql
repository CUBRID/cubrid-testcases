--update order by with limit condition


create table uoo(
	col1 int,
	col2 char(10),
	col3 date,
	col4 numeric
);

insert into uoo values 
	(1, 'fff', '2008-10-04', 25), 
	(4, 'ccc', '05/30/2010', 101),
	(3, 'aaa', '04/21/1993', 13),
	(5, 'ddd', '2012-12-12', 33),
	(2, 'bbb', '03/23/1878', 11);

select * from uoo order by col1;

update uoo set col2='updated...', col4=col4-4 order by col1 limit 3;
select * from uoo order by col1, col4;

update uoo set col1=col1*10, col2='updated2' order by col1 desc limit 3;
select * from uoo order by col1, col4;

update uoo set col1=col1/10, col2='updated3' order by col4 desc limit 6;
select * from uoo order by col1, col4;

update uoo set col1=col1-10, col2='updated4' order by col3 desc limit 2;
select * from uoo order by col3, col4;


drop table uoo;
