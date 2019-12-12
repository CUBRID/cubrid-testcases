--TEST: test with columns with constraints


create table rank_constraints(
	col1 int not null,
        col2 short auto_increment,
        col3 bigint default 10000000,
        col4 numeric(10, 5) not null,
        col5 float unique,
        col6 double primary key,
        col7 monetary shared 500
);


insert into rank_constraints values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into rank_constraints values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into rank_constraints values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 3000);
insert into rank_constraints values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into rank_constraints values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into rank_constraints values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 6000);
insert into rank_constraints values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into rank_constraints values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into rank_constraints values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 8000);
insert into rank_constraints values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into rank_constraints values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into rank_constraints values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into rank_constraints values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 2000);
insert into rank_constraints values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into rank_constraints values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into rank_constraints values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into rank_constraints values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 6000);
insert into rank_constraints values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into rank_constraints values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into rank_constraints values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 3000);


--TEST: OVER() clause
--TEST: no aliases 
select col1, col2, rank() over() from rank_constraints order by 1, 2;
--TEST: with alias
select col2, col3, rank() over() rank from rank_constraints order by 1, 2;
--TEST: with where clause
select col3, col4, rank() over() rank from rank_constraints where col1 > 10000 order by col3, col4;
--TEST: 
select col5, col6, col7, rank() over() rank from rank_constraints order by col5;
--TEST: 
select col6, col1, col2, col5, rank() over() rank from rank_constraints where length(col3)=8 and round(col5)=111 order by 4;
--TEST: 
select col7, col3, col5, rank() over() rank from rank_constraints order by 2, 3;
--TEST: no matched rows
select col1, col2, col3, col4, col5, col6, col7, rank() over() rank from rank_constraints where trunc(col6)=111 order by 1, 2, 3, 4, 5, 6;
--TEST: syntax error
select *, rank() over() rank from rank_constraints order by 1, 2, 3, 4, 5, 6, 7, 8;
select col1, col3, col5, rank() over rank from rank_constraints;
select col1, col3, col5, rank() over(1) rank from rank_constraints;
--TEST: without over clause
select col1, rank() rank from rank_constraints;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col1) rank from rank_constraints order by 1, 2, 3, 4, 5, 6;
--TEST: partition by smallint
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col2) rank from rank_constraints order by 2, 1, 3, 4, 5, 6;
--TEST: partition by bigint
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col3) rank from rank_constraints order by 3, 1, 2, 4, 5, 6;
--TEST: partition by numeric
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col4) rank from rank_constraints order by 4, 1, 2, 3, 5, 6;
--TEST: partition by float
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col5) rank from rank_constraints order by 5;
--TEST: partition by double
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col6) rank from rank_constraints order by 6;
--TEST: partition by monetary
select col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col7) rank from rank_constraints order by 1, 2, 3, 4, 5, 6;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, rank() over(order by col1) rank from rank_constraints order by 1, 2;
--TEST: order by 2 column names
select col2, col3, rank() over(order by col2, col3 asc) rank from rank_constraints order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, col6, col7, rank() over(order by col1, col2 desc, col3, col4 asc, col5, col6 desc) rank from rank_constraints order by 1, 2, 3, 4, 5, 6, 7, 8;
--TEST: order by columns not selected
select col3, rank() over(order by col4, col6 desc, col2, col1 asc) rank from rank_constraints order by 1, 2;
--TEST: order by 1 position
select col5, rank() over(order by 1) rank from rank_constraints order by 1, 2;
--TEST: order by 3 positions
select col3, col5, rank() over(order by 1, 2 desc, 3 asc) rank from rank_constraints order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, col6, col7, rank() over(order by 5, 3, 7, 2 asc, 1 desc, 6 desc, 4) rank from rank_constraints order by 1, 2, 3, 4, 5, 6, 7, 8;
--TEST: order by positions not existed
select col5, rank() over(order by 2) rank from rank_constraints order by 1, 2;
select col1, rank() over(order by 3, 4, 1 desc) row_num, col5, col7 from rank_constraints order by 1, 2;
select col3, col5, rank() over(order by 5) rank from rank_constraints order by 1, 2;
select col3, col5, rank() over(order by 100) rank from rank_constraints order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, col6, col7, rank() over(order by 1, col2 desc, 3, col4 asc, 5, col6 desc, 7) rank from rank_constraints order by 1, 2, 3, 4, 5, 6, 7, 8;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select col1, col2, col3, rank() over(partition by col1 order by 1, 2, 3) from rank_constraints order by 1, 2, 3, 4;
--TEST: partition by smallint
select col2, col4, col5, rank() over(partition by col2 order by col2, col4, col5 desc) from rank_constraints order by 1, 2, 3, 4;
--TEST: partition by bigint
select col3, rank() over(partition by col3 order by 1, 3) rank, col5 from rank_constraints order by 1, 2;
--TEST: partition by numeric
select col4, col1, rank() over(partition by col4 order by 1, 2 desc) rank from rank_constraints order by 1, 2, 3;
--TEST: partition by float
select col5, col6, rank() over(partition by col5 order by col5 desc, col6 asc) rank from rank_constraints order by 1, 2, 3;
--TEST: partition by double
select col6, col1, col2, col3, rank() over(partition by col6 order by col2, col3 desc) rank from rank_constraints order by 1, 2, 3, 4, 5;
--TEST: partition by monetary
select col7, col1, col2, col3, col4, col5, col6, col7, rank() over(partition by col7 order by col1, col2, col3 asc, col6) rank from rank_constraints order by 1, 2, 3, 4, 5, 6, 7, 8;
--TEST: syntax error
select col1, col2, rank() over(order by col1, col2 partition by col2) from rank_constraints order by 1, 2;



drop table rank_constraints; 















