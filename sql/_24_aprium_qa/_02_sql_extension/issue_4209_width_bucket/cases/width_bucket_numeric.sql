--TEST: test with columns with numeric 
--+ holdcas on;

create table wb_numeric(
	col1 int not null,
	col2 short auto_increment, 
	col3 bigint default 10000000,
	col4 numeric(10, 5) not null,
	col5 float unique,
	col6 double primary key,
	col7 monetary shared 500
);


insert into wb_numeric values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into wb_numeric values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into wb_numeric values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into wb_numeric values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into wb_numeric values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into wb_numeric values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into wb_numeric values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into wb_numeric values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into wb_numeric values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);
insert into wb_numeric values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into wb_numeric values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into wb_numeric values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into wb_numeric values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);
insert into wb_numeric values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into wb_numeric values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into wb_numeric values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into wb_numeric values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into wb_numeric values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into wb_numeric values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into wb_numeric values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: int 
select col1, col2, width_bucket(col1, 10000, 50000, 5) wb from wb_numeric order by 1, 2;
select col1, col2, width_bucket(col1, 10000, 50001, 5) wb from wb_numeric order by 1, 2;
select col1, col2, width_bucket(col1, 10000, 50001, 3) wb from wb_numeric order by 1, 2;
select col1, col2, width_bucket(col1, 10000, 50001, 10) wb from wb_numeric order by 1, 2;
--TEST: short
select col2, col3, width_bucket(col2, 100, 300, 5) wb from wb_numeric order by 1, 2;
--TEST: bigint, with where clause
select col3, col4, width_bucket(col3, 10000000, 80000001, 8) wb from wb_numeric where col1 > 10000 order by col3, col4;
--TEST: numeric
--select col4, col5, width_bucket(col4, 12345.06789, 12345.56789, 5) wb from wb_numeric order by 1, 2;
--TEST: float
select col5, col6, width_bucket(col5, 111.11, 111.32, 20) wb from wb_numeric order by col5, col6;
--TEST: double
select col6, col1, width_bucket(col6, 11111.111, 11111.131, 10) wb from wb_numeric where length(col3)=8 and round(col5)=111 order by 1, 2, 3;
--TEST: monetary
select col7, col3, width_bucket(col7, 1000, 1001, 1) wb from wb_numeric order by 1, 2;


--TEST: pass a column name into the max/min param
select col1, col2, width_bucket(col1, col1, 50000, 5) wb from wb_numeric order by 1, 2;
select col2, col3, width_bucket(col2, 100, col2+300, 5) wb from wb_numeric order by 1, 2;
select col3, col4, width_bucket(col3, col3-10000000, col3+100000, 10) wb from wb_numeric order by 1, 2;
--TEST: pass a column name into the count param
--select col4, width_bucket(col4, 12345.06789, 12345.56789, col2/10) wb from wb_numeric order by 1, 2;

drop table wb_numeric; 

commit;
--+ holdcas off;













