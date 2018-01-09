--TEST: test with columns with constraints 


create table ntile_num(
	col1 int not null,
        col2 short auto_increment,
        col3 bigint default 10000000,
        col4 numeric(10, 5) not null,
        col5 float unique,
        col6 double primary key,
        col7 monetary shared 500
);


insert into ntile_num values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into ntile_num values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into ntile_num values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into ntile_num values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into ntile_num values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into ntile_num values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into ntile_num values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into ntile_num values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into ntile_num values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);
insert into ntile_num values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into ntile_num values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into ntile_num values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into ntile_num values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);
insert into ntile_num values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into ntile_num values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into ntile_num values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into ntile_num values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into ntile_num values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into ntile_num values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into ntile_num values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: OVER() clause 
select new.col1, new.col2, ntile(10) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3;
select new.col1, new.col2, ntile(10) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1 desc, 2, 3;
select new.col1, new.col2, ntile(20) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3;
select new.col1, new.col2, ntile(30) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3;
--TEST: over(), with where clause
select col1, col2, ntile(5) over(order by col1, col2) b_num from ntile_num where col1 > 20000 order by 1, 2, 3;
select new.col6, new.col1, new.col2, new.col5, ntile(2) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new where length(new.col3)=8 and round(new.col5)=111 order by 1;
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(10) over() b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new where trunc(new.col5)=111 order by 1, 2, 3, 4;
select *, ntile(20) over() b_num from (select * from ntile_num order by 1, 2, 3, 4, 5, 6);
--TEST: syntax error
select col1, col3, col5, ntile() over b_num from ntile_num;
select col1, col3, col5, ntile() over(1) b_num from ntile_num;
--TEST: without over clause
select col1, ntile() b_num from ntile_num;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by int
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(3) over(partition by new.col1) b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3, 4, 5, 6;
--TEST: partition by smallint
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(4) over(partition by new.col2) b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 2, 1, 3, 4, 5, 6;
--TEST: partition by bigint
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(5) over(partition by new.col3) b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 3, 1, 2, 4, 5, 6;
--TEST: partition by numeric
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(2) over(partition by new.col4) b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 4, 1, 2, 3, 5, 6;
--TEST: partition by float
select col1, col2, col3, col4, col5, col6, col7, ntile(10) over(partition by col5) b_num from ntile_num order by 5;
--TEST: partition by double
select col1, col2, col3, col4, col5, col6, col7, ntile(1) over(partition by col6) b_num from ntile_num order by 6;
--TEST: partition by monetary
select new.col1, new.col2, new.col3, new.col4, new.col5, new.col6, new.col7, ntile(11) over(partition by new.col7) b_num from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2, 3, 4, 5, 6;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, ntile(5) over(order by col1) b_num from ntile_num;
--TEST: order by 2 column names
select col2, col3, ntile(7) over(order by col2, col3 asc) b_num from ntile_num;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, col6, col7, ntile(13) over(order by col1, col2 desc, col3, col4 asc, col5, col6 desc) b_num from ntile_num;
--TEST: order by columns not selected
select col3, ntile(9) over(order by col4, col6 desc, col2, col1 asc) b_num from ntile_num;
--TEST: order by 1 position
select col5, ntile(1) over(order by 1) b_num from ntile_num;
--TEST: order by 3 positions
select col3, col5, ntile(100) over(order by 1, 2 desc, 3 asc) b_num from ntile_num;
--TEST: order by more than 3 positionos
select col1, col2, col3, col4, col5, col6, col7, ntile(20) over(order by 5, 3, 7, 2 asc, 1 desc, 6 desc, 4) b_num from ntile_num;
--TEST: order by positions not existed
select col5, ntile(2) over(order by 2) b_num from ntile_num;
select col1, ntile(3) over(order by 3, 4, 1 desc) b_num, col5, col7 from ntile_num;
select col3, col5, ntile(4) over(order by 5) b_num from ntile_num;
select col3, col5, ntile(5) over(order by 100) b_num from ntile_num;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, col6, col7, ntile(10) over(order by 1, col2 desc, 3, col4 asc, 5, col6 desc, 7) b_num from ntile_num;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by int
select col1, col2, col3, ntile(5) over(partition by col1 order by 1, 2, 3) from ntile_num;
--TEST: partition by smallint
select col2, col4, col5, ntile(3) over(partition by col2 order by col2, col4, col5 desc) from ntile_num;
--TEST: partition by bigint
select col3, ntile(7) over(partition by col3 order by 1, 3) b_num, col5 from ntile_num;
--TEST: partition by numeric
select col4, col1, ntile(9) over(partition by col4 order by 1, 2 desc) b_num from ntile_num;
--TEST: partition by float
select col5, col6, ntile(10) over(partition by col5 order by col6 asc) b_num from ntile_num;
--TEST: partition by double
select col6, col1, col2, col3, ntile(2) over(partition by col6 order by col5 desc) b_num from ntile_num;
--TEST: partition by monetary
select col7, col1, col2, col3, col4, col5, col6, col7, ntile(6) over(partition by col7 order by col1, col2, col3 asc, col6) b_num from ntile_num;
--TEST: syntax error
select col1, col2, ntile(5) over(order by col1, col2 partition by col2) from ntile_num;



--TEST: pass column name as argument of ntile()
select new.col1, ntile(new.col1) over(order by new.col2) from (select * from ntile_num order by 1,2,3,4,5,6,7) new order by 1, 2;

drop table ntile_num; 















