--TEST: test with tables with list partition

drop table if exists p_cont;
create table p_cont(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
)
partition by range(col1)
(partition p1 values less than (20000),
partition p2 values less than (30000),
partition p3 values less than (40000),
partition p4 values less than (50000),
partition p5 values less than (60000)
);


insert into p_cont values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into p_cont values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into p_cont values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into p_cont values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into p_cont values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into p_cont values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into p_cont values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into p_cont values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into p_cont values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);
insert into p_cont values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into p_cont values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into p_cont values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into p_cont values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);
insert into p_cont values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into p_cont values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into p_cont values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into p_cont values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into p_cont values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into p_cont values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into p_cont values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: OVER() clause
--TEST: int 
select col1, col2, percentile_cont(0.1) within group (order by col1 asc) over() p_cont from p_cont order by 1, 2, 3;
--TEST: short, with alias
select col2, col3, percentile_cont(0.2) within group (order by col2) over() p_cont from p_cont order by 1, 2, 3;
--TEST: bigint, with where clause
select col3, col4, percentile_cont(0.3) within group (order by col3 desc) over() p_cont from p_cont where col1 > 10000 order by 1, 2, 3;
--TEST: numeric,
select col4, col5, percentile_cont(0.4) within group (order by col4) over() p_cont from p_cont order by 1, 2, 3;
--TEST: float,
select col5, col6, col7, percentile_cont(0.5) within group (order by col5) over() p_cont from p_cont order by 1, 2, 3, 4;
--TEST: double,
select col6, col1, col2, col5, percentile_cont(0.6) within group (order by col6) over() p_cont from p_cont where length(col3)=8 and round(col5)=111 order by 1, 2, 3;
--TEST: monetary,
select col7, col3, col5, percentile_cont(0.7) within group (order by col7 desc) over() p_cont from p_cont order by 1, 2, 3;
--TEST: no matched rows
select col1, col2, col3, col4, col5, col6, col7, percentile_cont(0.88) within group (order by col1) over() p_cont from p_cont where trunc(col6)=111 order by 1, 2, 3, 4, 5, 6, 7;
select *, percentile_cont(0.999) within group (order by col2) over() p_cont from p_cont) order by 1, 2, 3, 4, 5, 6, 7;
--TEST: syntax error
select col1, col3, col5, percentile_cont(0) within group (order by col2) over p_cont from p_cont;
select col1, col3, col5, percentile_cont(0.5) within group (order by col2) over(1) p_cont from p_cont;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select col1, percentile_cont(0) within group (order by col3) over(partition by col1) p_cont from p_cont order by 1, 2;
--TEST: partition by smallint
select col2, percentile_cont(0.77) within group (order by col4) over(partition by col2) p_cont from p_cont order by 1, 2;
--TEST: partition by bigint
select col3, percentile_cont(0.88) within group (order by col4 desc) over(partition by col3) p_cont from p_cont order by 1, 2;
--TEST: partition by numeric
select col4, percentile_cont(0.99) within group (order by col2) over(partition by col4) p_cont from p_cont order by 1, 2;
--TEST: partition by float
select col5, percentile_cont(1) within group (order by col5) over(partition by col5) p_cont from p_cont order by 1, 2;
--TEST: partition by double
select col6, percentile_cont(0.11) within group (order by col4 desc) over(partition by col6) p_cont from p_cont order by 1, 2;
--TEST: partition by monetary
select col7, percentile_cont(0.22) within group (order by col7) over(partition by col7) p_cont from p_cont order by 1, 2;



--TEST: [er] OVER(ORDER BY) clause
select col1, percentile_cont(0.8) within group (order by col2) over(order by col1) p_cont from p_cont order by 1, 2, 3;



--TEST: [er] OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select col1, col2, col3, percentile_cont(0.8) within group (order by col4) over(partition by col1 order by col2, col3) from p_cont order by 1, 2, 3;


drop table p_cont; 















