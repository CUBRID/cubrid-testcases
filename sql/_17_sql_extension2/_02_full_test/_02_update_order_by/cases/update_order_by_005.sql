--simple case: order by different data types:
--monetary, bit(n), multiset


create table uoo(
	col1 monetary,
	col2 bit(20),
	col3 multiset
);

insert into uoo values 
	(1, X'fff', {10,20,30}), 
	(4, X'ccc', {12,13,14}),
	(3, X'aaa', {2,5,8}),
	(5, X'ddd', {1.1, 2.2, 3.3}),
	(2, X'bbb', {20,40,60});

select * from uoo order by col1;

update uoo set col1=col1+2 order by col1;
select * from uoo order by col1;

update uoo set col1=col1+2 order by col2;
select * from uoo order by col1;

update uoo set col1=col1+2 order by col3;
select * from uoo order by col1;

drop table uoo;
