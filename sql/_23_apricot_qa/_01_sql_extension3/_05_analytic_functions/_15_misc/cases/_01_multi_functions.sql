--TEST: null values included in the table 


create table multi(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
);


insert into multi values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into multi values(10000, 200, null, 12345.06789, 111.12, 11111.129, 1000);
insert into multi values(10000, null, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into multi values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into multi values(null, 100, 50000000, null, 111.15, 11111.126, 1000);
insert into multi values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into multi values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into multi values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into multi values(null, 300, 20000000, null, 111.19, 11111.122, 1000);
insert into multi values(30000, null, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into multi values(30000, 100, 40000000, null, 111.21, 11111.120, 1000);
insert into multi values(null, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into multi values(40000, 100, 10000000, 12345.06789, 111.24, null, 1000);
insert into multi values(50000, null, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into multi values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into multi values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into multi values(null, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into multi values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into multi values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into multi values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: select multiple functions in one statement, over() clause
select row_number() over() rn, count(col1) over() ct, rank() over() rk, dense_rank() over() drk, avg(col2) over() ag, max(col3) over() mx, min(col4) over() mn, stddev(col3) over() std, stddev_pop(col3) over() spop, stddev_samp(col3) over() ssamp, sum(col1) over() sm, var_pop(col2) over() vpop, variance(col2) over() var, var_samp(col2) over() vsamp from multi order by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14;



drop table multi;






