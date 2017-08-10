--TEST: test with prepared statements 


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
prepare st from 'select col1, col2, width_bucket(col1, ?, 50000, 5) wb from wb_numeric order by 1, 2';
execute st using 10000;
prepare st from 'select col1, col2, width_bucket(col1, ?, ?, 5) wb from wb_numeric order by 1, 2';
execute st using 10000, 50001;
prepare st from 'select col1, col2, width_bucket(col1, 10000, ?, ?) wb from wb_numeric order by 1, 2';
execute st using 60000, 4;
prepare st from 'select col1, col2, width_bucket(col1, ?, ?, ?) wb from wb_numeric order by 1, 2';
execute st using 1, 60000, 300;
--TEST: short
prepare st from 'select col2, col3, width_bucket(col2, ?, ?, ?) wb from wb_numeric order by 1, 2';
execute st using 99, 500, 20;
--TEST: bigint, with where clause
prepare st from 'select col3, col4, width_bucket(col3, ?, ?, 8) wb from wb_numeric where col1 > 10000 order by col3, col4';
execute st using 20, 2000000;
--TEST: numeric
prepare st from 'select col4, col5, width_bucket(col4, ?, ?, ?) wb from wb_numeric order by 1, 2';
execute st using 12345.01, 12345.60, 20;
--TEST: float
prepare st from 'select col5, col6, width_bucket(col5, ?, 111.32, ?) wb from wb_numeric order by col5, col6';
execute st using 100, 30;
--TEST: double
prepare st from 'select col6, col1, width_bucket(col6, ?, ?, ?) wb from wb_numeric where length(col3)=8 and round(col5)=111 order by 1, 2, 3';
execute st using 11111, 11112, 10;
--TEST: monetary
prepare st from 'select col7, col3, width_bucket(col7, ?, ?, ?) wb from wb_numeric order by 1, 2';
execute st using 1000, 999, 1;


deallocate prepare st;
drop table wb_numeric; 















