-- test with numeric data types and normal cases
-- syntax: LEAD(expr, offset, default) 


create table lead_num(
	col1 int not null,
	col2 short auto_increment, 
	col3 bigint default 10000000,
	col4 numeric(10, 5),
	col5 float unique,
	col6 double primary key,
	col7 monetary shared 500
);


insert into lead_num values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into lead_num values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into lead_num values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into lead_num values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into lead_num values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, null);
insert into lead_num values(20000, null, 70000000, null, 111.16, 11111.125, 1000);
insert into lead_num values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into lead_num values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into lead_num values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 2000);
insert into lead_num values(30000, 100, null, 12345.06789, 111.20, 11111.121, 1000);
insert into lead_num values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into lead_num values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into lead_num values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 3000);
insert into lead_num values(50000, 100, 20000000, null, 111.25, 11111.117, 1000);
insert into lead_num values(50000, null, 30000000, 12345.06789, 111.26, 11111.116, 4000);
insert into lead_num values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into lead_num values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into lead_num values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 5000);
insert into lead_num values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into lead_num values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 8000);


--TEST: OVER() clause
--TEST: int 
select new.col1, new.col2, lead(new.col1) over() from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 1, 2;
--TEST: short, with alias
select new.col2, new.col3, lead(new.col2, 1) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 1, 2;
--TEST: bigint, with where clause
select col3, col4, lead(col3, 2) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) where col1 > 10000 order by col3, col4;
--TEST: numeric
select new.col4, new.col5, lead(new.col4, 3) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 1, 2;
--TEST: float
select new.col5, new.col6, new.col7, lead(new.col5, 1, 999) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by new.col5, new.col6, new.col7;
--TEST: double
select new.col6, new.col1, new.col2, new.col5, lead(new.col6, 15, null) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new where length(new.col3)=8 and round(new.col5)=111 order by 1, 2, 3, 4;
--TEST: monetary, offset out of range
select col7, col3, col5, lead(col7, 30) over() next_v from lead_num order by 2, 3;
--TEST: no matched rows
select col1, col2, col3, col4, col5, col6, col7, lead(col7, 2, -100) over() next_v from lead_num where trunc(col6)=111 order by 1, 2, 3, 4, 5, 6;
--TEST: syntax error
select new.*, lead(new.col1) over() next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new;
select col1, col3, col5, lead(col2) over next_v from lead_num;
select col1, col3, col5, lead(col3) over(1) next_v from lead_num;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, lead(new.col2) over(partition by new.col1) next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3, 4, 5, 6;
--TEST: partition by smallint
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, lead(new.col4, 2) over(partition by new.col2) next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 2, 1, 3, 4, 5, 6;
--TEST: partition by bigint
select col1, col2, col3, col4, col5, col6, col7, lead(col6, 3, 999) over(partition by col3) next_v from lead_num order by 3, 1, 2, 4, 5, 6;
--TEST: [er], partition by numeric
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6,new.col7, lead(new.col2, 1, 10) over(partition by new.col4) next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 4, 1, 2, 3, 5, 6;
--TEST: partition by float, 0 as offset
select col1, col2, col3, col4, col5, col6, col7, lead(col4, 0, 9999.999) over(partition by col5) next_v from lead_num order by 5, 1, 2, 3, 4, 6;
--TEST: partition by double
select col1, col2, col3, col4, col5, col6, col7, lead(col3, 10) over(partition by col6) next_v from lead_num order by 6, 1, 2, 3, 4, 5;
--TEST: partition by monetary
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, lead(new.col7, 4, 1111111) over(partition by new.col7) next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3, 4, 5, 6;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, lead(col1) over(order by col1) next_v from lead_num;
--TEST: order by 2 column names
select col2, col3, lead(col2, 2) over(order by col2, col3 asc) next_v from (select * from lead_num order by 1,2,3,4,5,6,7);
--TEST: order by more than 2 column names
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, lead(new.col3, 1, 0) over(order by new.col3) next_v from (select * from lead_num order by 1,2,3,4,5,6,7) new;
--TEST: order by columns not selected
select col3, lead(col4, 2, 0.9999999) over(order by col4, col6 desc, col2, col1 asc) next_v from lead_num;
--TEST: order by 1 position
select col5, lead(col2, 1, 0) over(order by 2) next_v from lead_num;
--TEST: order by 3 positions
select col3, col5, lead(col5, 2) over(order by 2 desc, 1, 3 asc) next_v from lead_num;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, col6, col7, lead(col6, 10, 999.999) over(order by 5, 3, 7, 2 asc, 1 desc, 6 desc, 4) next_v from lead_num;
--TEST: order by positions not existed
select col5, lead(col7) over(order by 2) next_v from lead_num;
select col1, lead(col3, 1, 99999) over(order by 3, 4, 1 desc) next_v, col5, col7 from lead_num;
select col3, col5, lead(col5, 30) over(order by 5) next_v from lead_num;
select col3, col5, lead(col7, 8, -100000) over(order by 100) next_v from lead_num;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, col6, col7, lead(col3, 4, -999) over(order by 1, col2 desc, 3, col4 asc, 5, col6 desc, 7) next_v from lead_num;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select col1, col2, col3, lead(col4) over(partition by col1 order by 1, 2, 3) from lead_num;
--TEST: partition by smallint
select col2, col4, col5, lead(col5, 1, null) over(partition by col2 order by col2, col4, col5 desc) from lead_num;
--TEST: partition by bigint
select col3, lead(col7, 3) over(partition by col3 order by 1, 3) next_v, col5 from lead_num;
--TEST: partition by numeric
select col4, col1, lead(col6, 10, 0.00) over(partition by col4 order by 1, 2 desc,col5) next_v from lead_num;
--TEST: partition by float
select col5, col6, lead(col2, 1, 999) over(partition by col5 desc order by col6 asc) next_v from lead_num;
--TEST: partition by double
select col6, col1, col2, col3, lead(col7) over(partition by col6 order by 5,4,3 desc,2,1) next_v from lead_num;
--TEST: partition by monetary
select col7, col1, col2, col3, col4, col5, col6, col7, lead(col4, 100, 22222.22222) over(partition by col7 order by 1 desc, col1, col2, col3 asc, 5, 6, col7 desc) next_v from lead_num;
--TEST: syntax error
select col1, col2, lead(col3, 3, 1) over(order by col1, col2 partition by col2) from lead_num;



drop table lead_num; 















