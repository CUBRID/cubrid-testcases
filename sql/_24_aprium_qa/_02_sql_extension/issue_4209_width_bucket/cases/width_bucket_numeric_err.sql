--TEST: error and special cases with numeric types 
--+ holdcas on;

create table wb_num_err(
	col1 int not null,
	col2 short auto_increment, 
	col3 bigint default 10000000,
	col4 numeric(10, 5) not null,
	col5 float unique,
	col6 double primary key,
	col7 monetary shared 500
);


insert into wb_num_err values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);
insert into wb_num_err values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);
insert into wb_num_err values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);
insert into wb_num_err values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);
insert into wb_num_err values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);
insert into wb_num_err values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);
insert into wb_num_err values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);
insert into wb_num_err values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);
insert into wb_num_err values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);
insert into wb_num_err values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);
insert into wb_num_err values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);
insert into wb_num_err values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);
insert into wb_num_err values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);
insert into wb_num_err values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);
insert into wb_num_err values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into wb_num_err values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);
insert into wb_num_err values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);
insert into wb_num_err values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);
insert into wb_num_err values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);
insert into wb_num_err values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);


--TEST: exp[all] < min 
select col1, col2, width_bucket(col1, 100000, 500000, 5) wb from wb_num_err order by 1, 2;
select col2, col3, width_bucket(col2, 1000, 5001, 5) wb from wb_num_err order by 1, 2;

--TEST: exp[all] > max
select col3, col4, width_bucket(col3, 10000, 800001, 8) wb from wb_num_err where col1 > 10000 order by col3, col4;
select col4, col5, width_bucket(col4, -100, 0, 5) wb from wb_num_err order by 1, 2;

--TEST: exp:int   min/max:float
select col1, col2, width_bucket(col1, 11111.11, 55555.32, 20) wb from wb_num_err order by 1, 2;
--TEST: exp:float  min/max:int
select col5, col6, width_bucket(col5, 111, 112, 10) wb from wb_num_err where length(col3)=8 and round(col5)=111 order by 1, 2, 3;
--TEST: count:float
select col7, col1, width_bucket(col7, 1000, 2000, 12.3333333) wb from wb_num_err order by 1, 2;
select col7, col1, width_bucket(col7, 900, 999, 12.9999) wb from wb_num_err order by 1, 2;

--TEST: constant as exp
select width_bucket(100, -1, 200, 5);
select col2, width_bucket(-13.1111, col2, col1, 5) from wb_num_err order by 1, 2;

--TEST: [er] min = max
select col1, col2, width_bucket(col1, 1, 1, 5) wb from wb_num_err order by 1, 2;
--TEST: [er] min > max
select col2, col3, width_bucket(col2, 300, 100, 5) wb from wb_num_err order by 1, 2;
--TEST: [er] count <= 0
select col3, col4, width_bucket(col3, 10000, 800001, 0) wb from wb_num_err order by 1, 2;
select col3, col4, width_bucket(col3, 10000, 800001, -100) wb from wb_num_err order by 1, 2;

--TEST: marginal values of min and max
select col1, width_bucket(col1, -1.7976931348623157E+308, 1.7976931348623157E+308, 100000000) wb from wb_num_err;
select col1, width_bucket(col1, -2147483648, 2147483647, 10) wb from wb_num_err;
select col1, width_bucket(col1, -3.402823466E+38, +3.402823466E+38, 100000000) wb from wb_num_err;
--TEST: big/marginal values to count
select col6, col1, width_bucket(col6, 11111.111, 11111.131, 10000000) wb from wb_num_err;
select col6, col1, width_bucket(col6, 11111.111, 11111.131, 2147483647) wb from wb_num_err;
select col3, col4, width_bucket(col3, 10000000, 80000001, 3.402823466E+38) wb from wb_num_err where col1 > 10000 order by col3, col4;
select col2, col3, width_bucket(col2, 100, 300, 1.7976931348623157E+308) wb from wb_num_err order by 1, 2;

--TEST: [er] out-of-range values of min and max
select col1, width_bucket(col1, -1.7976931348623157E+309, 1.7976931348623157E+308, 100000000) wb from wb_num_err;
--select col4, col5, width_bucket(col4, 12345.06789, 1.7976931348623157E+308, 5) wb from wb_num_err order by 1, 2;
--TEST: [er] out-of-range value to count
select col3, col4, width_bucket(col3, 10000000, 80000001, 3.402823466E+40) wb from wb_num_err;
--TEST: [er] out-of-range value to exp
select col3, col4, width_bucket(3.402823466E+40, 10000000, 80000001, 3) wb from wb_num_err;

--TEST: null values
select col1, width_bucket(null, 5, 10, 5) wb from wb_num_err;
select col1, width_bucket(col1, null, 10, 5) wb from wb_num_err;
select col2, width_bucket(col2, 5, null, 5) wb from wb_num_err;
select col2, width_bucket(col2, 200, 800, null) wb from wb_num_err;


drop table wb_num_err; 

commit;
--+ holdcas off;














