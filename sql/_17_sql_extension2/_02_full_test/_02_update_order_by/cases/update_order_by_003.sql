--simple case: order by different data types:
--bigint, nchar(n), datetime, float


create table uoo(
	col1 bigint,
	col2 nchar(10),
	col3 datetime,
	col4 float
);

insert into uoo values 
	(1, n'fff', '2008-10-04 10:10:10 pm', 2.5), 
	(4, n'ccc', '05/30/2010 1:1:1 am', 1.01),
	(3, n'aaa', '04/21/1993 4:40:14', 1.3),
	(5, n'ddd', '2012-12-12 12:12:12 pm', 3.3),
	(2, n'bbb', '03/23/1878 8:8:8 am', 1.1);

select * from uoo order by col1;

update uoo set col1=col1+2, col4=col4-0.4 order by col1;
select * from uoo order by col1;

update uoo set col1=col1+2, col4=col4-0.4 order by col2;
select * from uoo order by col1;

update uoo set col1=col1+2, col4=col4-0.4 order by col3;
select * from uoo order by col1;

update uoo set col1=col1+2, col4=col4-0.4 order by col4;
select * from uoo order by col1;


drop table uoo;
