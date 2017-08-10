--test all kinds of date/time types for the 2nd and more parameters


create table soo(
	col1 date,
	col2 time,
	col3 timestamp,
	col4 datetime
);



insert into soo values (date'2010-10-25', time'13:25:21', timestamp'2010-10-25 13:25:21', datetime'2010-10-25 13:25:21.123');


select elt(1, col1, col2, col3, col4) from soo;
select elt(2, col1, col2, col3, col4) from soo;
select elt(3, col1, col2, col3, col4) from soo;
select elt(4, col1, col2, col3, col4) from soo;


drop table soo;
