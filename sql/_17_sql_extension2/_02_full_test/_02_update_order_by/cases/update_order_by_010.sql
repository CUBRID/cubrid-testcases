--update table with with a unique index
--update order by asc and desc


create table uoo(
	col1 smallint,
	col2 varchar(10),
	col3 time unique,
	col4 set
);

insert into uoo values 
	(1, 'fff', '10:30:42 am', {1,2,3}), 
	(4, 'ccc', '4:31:12', {5,2,1}),
	(3, 'aaa', '20:12:41', {12,34,21}),
	(5, 'ddd', '2:24:39 pm', {4,4,4}),
	(2, 'bbb', '0:14:22', {67,11,22});

select * from uoo order by col1;

update uoo set col1=col1+2 order by col1;
select * from uoo order by col1;

update uoo set col2='hahahaha' where col1<5 order by col3;
select * from uoo order by col1;

--error, unique violation
update uoo set col3='2:24:39 pm' order by col1 desc;
select * from uoo order by col1;

--error, unique violation
update uoo set col3='0:14:22' order by col2 asc;
select * from uoo order by col1;


drop table uoo;
