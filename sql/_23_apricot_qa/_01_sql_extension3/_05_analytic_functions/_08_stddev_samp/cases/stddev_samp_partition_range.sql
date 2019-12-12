--TEST: test with tables with range partition 


create table stddev_samp_p_range(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
)
partition by range(col1)
(
partition p1 values less than (30000),
partition p2 values less than (40000),
partition p3 values less than (50000),
partition p4 values less than (60000),
partition p5 values less than (200000)
);


insert into stddev_samp_p_range values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into stddev_samp_p_range values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into stddev_samp_p_range values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into stddev_samp_p_range values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into stddev_samp_p_range values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into stddev_samp_p_range values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into stddev_samp_p_range values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into stddev_samp_p_range values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into stddev_samp_p_range values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);
insert into stddev_samp_p_range values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into stddev_samp_p_range values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into stddev_samp_p_range values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into stddev_samp_p_range values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);
insert into stddev_samp_p_range values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into stddev_samp_p_range values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into stddev_samp_p_range values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into stddev_samp_p_range values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into stddev_samp_p_range values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into stddev_samp_p_range values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into stddev_samp_p_range values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: select from partition
select ''||trunc(stddev_samp, 3) from (select  col1, col2, stddev_samp(col4) over() stddev_samp from stddev_samp_p_range__p__p1) order by 1;

--TEST: OVER() clause
--TEST: int 
select ''||trunc(stddev_samp, 3) from (select  col1, col2, stddev_samp(col1) over() stddev_samp from stddev_samp_p_range) order by 1;
--TEST: short, with alias
select ''||trunc(stddev_samp, 3) from (select  col2, col3, stddev_samp(col2) over() stddev_samp from stddev_samp_p_range) order by 1;
--TEST: bigint, with where clause
select ''||trunc(stddev_samp, 3) from (select  col3, col4, stddev_samp(col3) over() stddev_samp from stddev_samp_p_range where col1 > 10000) order by 1;
--TEST: numeric, distinct
select ''||trunc(stddev_samp, 3) from (select  col4, col5, stddev_samp(distinct col4) over() stddev_samp from stddev_samp_p_range) order by 1;
--TEST: float, all
select ''||trunc(stddev_samp, 3) from (select  col5, col6, col7, stddev_samp(all col5) over() stddev_samp from stddev_samp_p_range) order by 1;
--TEST: double, all
select ''||trunc(stddev_samp, 3) from (select  col6, col1, col2, col5, stddev_samp(all col6) over() stddev_samp from stddev_samp_p_range where length(col3)=8 and round(col5)=111) order by 1;
--TEST: monetary, distinct
select ''||trunc(stddev_samp, 3) from (select  col7, col3, col5, stddev_samp(distinct col7) over() stddev_samp from stddev_samp_p_range) order by 1;
--TEST: no matched rows
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(unique col1) over() stddev_samp from stddev_samp_p_range where trunc(col6)=111) order by 1;
--TEST: syntax error
select ''||trunc(stddev_samp, 3) from (select  *, stddev_samp(col2) over() stddev_samp from stddev_samp_p_range) order by 1;
select ''||trunc(stddev_samp, 3) from (select  col1, col3, col5, stddev_samp(col2) over stddev_samp from stddev_samp_p_range;
select ''||trunc(stddev_samp, 3) from (select  col1, col3, col5, stddev_samp(col3) over(1) stddev_samp from stddev_samp_p_range;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(unique col2) over(partition by col1) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by smallint
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(distinct col4) over(partition by col2) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by bigint
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(distinctrow col6) over(partition by col3) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by numeric
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(all col2) over(partition by col4) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by float
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(col3) over(partition by col5) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by double
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(all col4) over(partition by col6) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by monetary
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(distinct col7) over(partition by col7) stddev_samp from stddev_samp_p_range) order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select ''||trunc(stddev_samp, 3) from (select  col1, stddev_samp(col2) over(order by col1) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by 2 column names
select ''||trunc(stddev_samp, 3) from (select  col2, col3, stddev_samp(all col4) over(order by col2, col3 asc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by more than 2 column names
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(unique col4) over(order by col1, col2 desc, col3, col4 asc, col5, col6 desc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by columns not select trunc(stddev_samp, 3) from (select ed
select ''||trunc(stddev_samp, 3) from (select  col3, stddev_samp(distinct col2) over(order by col4, col6 desc, col2, col1 asc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by 1 position
select ''||trunc(stddev_samp, 3) from (select  col5, stddev_samp(all col2) over(order by 1) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by 3 positions
select ''||trunc(stddev_samp, 3) from (select  col3, col5, stddev_samp(col3) over(order by 1, 2 desc, 3 asc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by more than 3 positions
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(col7) over(order by 5, 3, 7, 2 asc, 1 desc, 6 desc, 4) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by positions not existed
select ''||trunc(stddev_samp, 3) from (select  col5, stddev_samp(distinct col1) over(order by 2) stddev_samp from stddev_samp_p_range) order by 1;
select ''||trunc(stddev_samp, 3) from (select  col1, stddev_samp(all col3) over(order by 3, 4, 1 desc) stddev_samp, col5, col7 from stddev_samp_p_range) order by 1;
select ''||trunc(stddev_samp, 3) from (select  col3, col5, stddev_samp(col4) over(order by 5) stddev_samp from stddev_samp_p_range) order by 1;
select ''||trunc(stddev_samp, 3) from (select  col3, col5, stddev_samp(col6) over(order by 100) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: order by column names and positions
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, col4, col5, col6, col7, stddev_samp(col4) over(order by 1, col2 desc, 3, col4 asc, 5, col6 desc, 7) stddev_samp from stddev_samp_p_range) order by 1;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select ''||trunc(stddev_samp, 3) from (select  col1, col2, col3, stddev_samp(distinct col4) over(partition by col1 order by 1, 2, 3) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by smallint
select ''||trunc(stddev_samp, 3) from (select  col2, col4, col5, stddev_samp(col5) over(partition by col2 order by col2, col4, col5 desc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by bigint
select ''||trunc(stddev_samp, 3) from (select  col3, stddev_samp(all col7) over(partition by col3 order by 1, 2, 3) stddev_samp, col5 from stddev_samp_p_range) order by 1;
--TEST: partition by numeric
select ''||trunc(stddev_samp, 3) from (select  col4, col1, stddev_samp(unique col1) over(partition by col4 order by 1, 2 desc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by float
select ''||trunc(stddev_samp, 3) from (select  col5, col6, stddev_samp(distinctrow col2) over(partition by col5 order by col5 desc, col6 asc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by double
select ''||trunc(stddev_samp, 3) from (select  col6, col1, col2, col3, stddev_samp(all col7) over(partition by col6 order by 5,4,3 desc,2,1) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: partition by monetary
select ''||trunc(stddev_samp, 3) from (select  col7, col1, col2, col3, col4, col5, col6, stddev_samp(col4+col5+col6) over(partition by col7 order by 1 desc, col1, col2, col3 asc, 5, 6, col7 desc) stddev_samp from stddev_samp_p_range) order by 1;
--TEST: syntax error
select col1, col2, stddev_samp(distinct col3*col7) over(order by col1, col2 partition by col2) from stddev_samp_p_range;



drop table stddev_samp_p_range; 















