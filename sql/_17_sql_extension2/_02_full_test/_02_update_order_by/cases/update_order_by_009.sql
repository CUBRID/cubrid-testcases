--update table with with primary key


create table uoo(
	col1 int primary key,
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

--error
update uoo set col1=col1+2, col4=col4-4 order by col1;
select * from uoo order by col1;

--error
update uoo set col1=col1+2, col4=col4-4 order by col1 asc;
select * from uoo order by col1;

update uoo set col1=col1+2, col4=col4-4 order by col1 desc;
select * from uoo order by col1;

drop table uoo;
