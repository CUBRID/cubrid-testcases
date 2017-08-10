--test all kinds of numeric types for the 1st parameter



create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(6, 4),
	col5 float,
	col6 double,
	col7 monetary
);



insert into soo values (1, 2, 3, 4.4, 4.77, 6.1234, 7);


--int
select elt(col1, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--smallint
select elt(col2, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--bigint
select elt(col3, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--numeric, TBD
select elt(col4, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--float, TBD
select elt(col5, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--double, TBD
select elt(col6, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;
--monetary
select elt(col7, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg') from soo;


drop table soo;
