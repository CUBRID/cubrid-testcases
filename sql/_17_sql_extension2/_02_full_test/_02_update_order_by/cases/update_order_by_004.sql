--simple case: order by different data types:
--double, nchar varying(n), timestamp, sequence

create table uoo(
	col1 double,
	col2 nchar varying(10),
	col3 timestamp,
	col4 sequence
);

insert into uoo values 
	(1, n'fff', '2008-10-04 10:10:10 pm', {10,20,30}), 
	(4, n'ccc', '05/30/2010 1:1:1 am', {12,13,14}),
	(3, n'aaa', '04/21/1993 4:40:14', {2,5,8}),
	(5, n'ddd', '2012-12-12 12:12:12 pm', {1.1, 2.2, 3.3}),
	(2, n'bbb', '03/23/1978 8:8:8 am', {20,40,60});

select * from uoo order by col1;

update uoo set col1=col1+2 order by col1;
select * from uoo order by col1;

update uoo set col1=col1+2 order by col2;
select * from uoo order by col1;

update uoo set col1=col1+2 order by col3;
select * from uoo order by col1;

update uoo set col1=col1+2 order by col4;
select * from uoo order by col1;


drop table uoo;
