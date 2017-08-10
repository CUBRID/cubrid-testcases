--TEST: null values included in the table 


create table stddev_null(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
);


insert into stddev_null values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into stddev_null values(10000, 200, null, 12345.06789, 111.12, 11111.129, 1000);
insert into stddev_null values(10000, null, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into stddev_null values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into stddev_null values(null, 100, 50000000, null, 111.15, 11111.126, 1000);
insert into stddev_null values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into stddev_null values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into stddev_null values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into stddev_null values(null, 300, 20000000, null, 111.19, 11111.122, 1000);
insert into stddev_null values(30000, null, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into stddev_null values(30000, 100, 40000000, null, 111.21, 11111.120, 1000);
insert into stddev_null values(null, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into stddev_null values(40000, 100, 10000000, 12345.06789, 111.24, null, 1000);
insert into stddev_null values(50000, null, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into stddev_null values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into stddev_null values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into stddev_null values(null, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into stddev_null values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into stddev_null values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into stddev_null values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: OVER() clause
--TEST: int 
select col1, col2, trunc(stddev(col1) over(), 2) stddev from stddev_null order by 1, 2;
--TEST: short, with alias
select col2, col3, trunc(stddev(col2) over(), 2) stddev from stddev_null order by 1, 2;
--TEST: bigint, with where clause
select col3, col4, trunc(stddev(col3) over(), 2) stddev from stddev_null where col1 > 10000 order by col3, col4;
--TEST: numeric, distinct
select col4, col5, trunc(stddev(distinct col4) over(), 2) stddev from stddev_null order by 1, 2;
--TEST: float, all
select col5, col6, col7, trunc(stddev(all col5) over(), 2) stddev from stddev_null order by col5, col6, col7;
--TEST: double, all
select col6, col1, col2, col5, trunc(stddev(all col6) over(), 2) stddev from stddev_null where length(col3)=8 and round(col5)=111 order by 1, 2, 3, 4;
--TEST: monetary, distinct
select col7, col3, col5, trunc(stddev(distinct col7) over(), 2) stddev from stddev_null order by 2, 3;
--TEST: no matched rows
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(col1) over(), 2) stddev from stddev_null where trunc(col6)=111 order by 1, 2, 3, 4, 5, 6;
--TEST: syntax error
select stddev from (select *, trunc(stddev(col2) over(), 2) stddev from stddev_null) order by 1;
select col1, col3, col5, trunc(stddev(col3) over stddev from stddev_null;
select col1, col3, col5, trunc(stddev(col4) over(1), 2) stddev from stddev_null;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(unique col2) over(partition by col1), 2) stddev from stddev_null order by 1, 2, 3, 4, 5, 6;
--TEST: partition by smallint
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(distinct col4) over(partition by col2), 2) stddev from stddev_null order by 2, 1, 3, 4, 5, 6;
--TEST: partition by bigint
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(all col3) over(partition by col3), 2) stddev from stddev_null order by 3, 1, 2, 4, 5, 6;
--TEST: partition by numeric
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(all col2) over(partition by col4), 2) stddev from stddev_null order by 4, 1, 2, 3, 5, 6;
--TEST: partition by float
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(distinctrow col4) over(partition by col5), 2) stddev from stddev_null order by 5, 1, 2, 3, 4, 6;
--TEST: partition by double
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(all col4) over(partition by col6), 2) stddev from stddev_null order by 6, 1, 2, 3, 4, 5;
--TEST: partition by monetary
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(distinct col7) over(partition by col7), 2) stddev from stddev_null order by 1, 2, 3, 4, 5, 6;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, trunc(stddev(col2) over(order by col1), 2) stddev1, trunc(stddev(col2) over(), 2) stddev2 from stddev_null;
--TEST: order by 2 column names
select col2, col3, trunc(stddev(all col4) over(order by col2, col3 asc), 2) stddev1, trunc(stddev(all col4) over(), 2) stddev2 from stddev_null;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(col5) over(order by col1, col2 desc, col3, col4 asc, col5, col6 desc), 2) stddev1, trunc(stddev(col5) over(), 2) stddev2 from stddev_null;
--TEST: order by columns not selected
select col3, trunc(stddev(distinct col2) over(order by col4, col6 desc, col2, col1 asc), 2) stddev1, trunc(stddev(distinct col2) over(), 2) stddev2 from stddev_null;
--TEST: order by 1 position
select col5, trunc(stddev(all col2) over(order by 1), 2) stddev from stddev_null;
--TEST: order by 3 positions
select col3, col5, trunc(stddev(unique col6) over(order by 1, 2 desc, 3 asc), 2) stddev from stddev_null;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(distinctrow col7) over(order by 5, 3, 7, 2 asc, 1 desc, 6 desc, 4), 2) stddev from stddev_null;
--TEST: order by positions not existed
select col5, trunc(stddev(distinct col1) over(order by 2), 2) stddev from stddev_null;
select col1, trunc(stddev(all col3) over(order by 3, 4, 1 desc), 2) stddev, col5, col7 from stddev_null;
select col3, col5, trunc(stddev(col4) over(order by 5), 2) stddev from stddev_null;
select col3, col5, trunc(stddev(col5) over(order by 100), 2) stddev from stddev_null;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, col6, col7, trunc(stddev(unique col6) over(order by 1, col2 desc, 3, col4 asc, 5, col6 desc, 7), 2) stddev from stddev_null;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select col1, col2, col3, trunc(stddev(distinct col4) over(partition by col1 order by col1, col2, col3), 2) stddev1, trunc(stddev(distinct col4) over(partition by col1), 2) stddev2 from stddev_null;
--TEST: partition by smallint
select col2, col4, col5, trunc(stddev(col5) over(partition by col2 order by col2, col4, col5 desc), 2) stddev1, trunc(stddev(col5) over(partition by col2), 2) stddev2 from stddev_null;
--TEST: partition by bigint
select col3, trunc(stddev(all col7) over(partition by col3 order by 1, 2, 3), 2) stddev, col5 from stddev_null;
--TEST: partition by numeric
select col4, col1, trunc(stddev(col4) over(partition by col4 order by col1, col2 desc), 2) stddev1, trunc(stddev(col4) over(partition by col4), 2) stddev2 from stddev_null;
--TEST: partition by float
select col5, col6, trunc(stddev(distinct col2) over(partition by col5 asc order by col6 asc), 2) stddev1, trunc(stddev(distinct col2) over(partition by col5 asc), 2) stddev2 from stddev_null;
--TEST: partition by double
select col6, col1, col2, col3, trunc(stddev(all col7) over(partition by col6 order by 5,4,3 desc,2,1), 2) stddev from stddev_null;
--TEST: partition by monetary
select col7, col1, col2, col3, col4, col5, col6, col7, trunc(stddev(col7) over(partition by col7 order by 1 desc, col1, col2, col3 asc, 5, 6, col7 desc), 2) stddev from stddev_null;
--TEST: syntax error
select col1, col2, trunc(stddev(distinct col3) over(order by col1, col2 partition by col2) from stddev_null;



drop table stddev_null; 















