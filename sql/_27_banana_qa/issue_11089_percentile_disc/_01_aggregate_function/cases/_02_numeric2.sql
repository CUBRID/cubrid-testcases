--TEST: pass numeric type values to the second param

drop table if exists p_disc;

create table p_disc(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
);


insert into p_disc values(1, 2, 1, 1234.06789, 0.11, 0.130, 0.55);
insert into p_disc values(1, 4, 2, 1234.06789, 0.12, 0.129, 0.55);
insert into p_disc values(1, 2, 3, 1234.16789, 0.13, 0.128, 0.55);
insert into p_disc values(1, 4, 4, 1234.06789, 0.14, 0.127, 0.55);
insert into p_disc values(1, 2, 5, 1234.16789, 0.15, 0.126, 0.55);
insert into p_disc values(3, 4, 7, 1234.06789, 0.16, 0.125, 0.55);
insert into p_disc values(3, 2, 8, 1234.06789, 0.17, 0.124, 0.55);
insert into p_disc values(3, 2, 1, 1234.26789, 0.18, 0.123, 0.55);
insert into p_disc values(3, 6, 2, 1234.06789, 0.19, 0.122, 0.55);
insert into p_disc values(5, 2, 3, 1234.06789, 0.20, 0.121, 0.55);
insert into p_disc values(5, 2, 4, 1234.16789, 0.21, 0.120, 0.55);
insert into p_disc values(5, 6, 5, 1234.06789, 0.23, 0.119, 0.55);
insert into p_disc values(7, 2, 1, 1234.06789, 0.24, 0.118, 0.55);
insert into p_disc values(9, 2, 2, 1234.06789, 0.25, 0.117, 0.55);
insert into p_disc values(9, 4, 3, 1234.06789, 0.26, 0.116, 0.55);
insert into p_disc values(9, 2, 4, 1234.56789, 0.27, 0.115, 0.55);
insert into p_disc values(9, 2, 5, 1234.06789, 0.28, 0.114, 0.55);
insert into p_disc values(9, 6, 6, 1234.56789, 0.29, 0.113, 0.55);
insert into p_disc values(9, 2, 7, 1234.06789, 0.30, 0.112, 0.55);
insert into p_disc values(9, 2, 8, 1234.56789, 0.31, 0.111, 0.55);


--test: pass constant values to the second param
select col2, percentile_disc(0.1) within group(order by 1) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.1) within group(order by 2) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.1) within group(order by 5) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.2) within group(order by 2) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.5) within group(order by 0.1) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.8) within group(order by -1) p_disc from p_disc group by col2 order by 1, 2;
select col2, percentile_disc(0.8) within group(order by 100) p_disc from p_disc group by col2 order by 1, 2;

--test: pass different types of columns to the second param
select col2, percentile_disc(0.1) within group(order by col1) p_disc from p_disc group by col2 order by 1, 2;
select col3, percentile_disc(0.2) within group(order by col2) p_disc from p_disc group by col3 order by 1, 2;
select col4, col5, percentile_disc(0.3) within group(order by col3) p_disc from p_disc group by col4, col5 order by 1, 2;
select col1, col3, col7, percentile_disc(0.4) within group(order by col3) p_disc from p_disc group by col1, col3, col7 order by 1, 2;
select col1, col3, percentile_disc(0.5) within group(order by col5) p_disc from p_disc group by col1, col3 having col3 > 3 order by 1, 2;
select col4, percentile_disc(0.6) within group(order by col6) p_disc from p_disc group by col4 order by 1, 2;
select col6, percentile_disc(0.7) within group(order by col7) p_disc from p_disc group by col6 having ceiling(col6*100) > 11 order by 1, 2;

--test: [er] pass more than 1 columns to the second param
select col2, percentile_disc(0.1) within group(order by col1, col3) p_disc from p_disc group by col2 order by 1, 2;
select col3, percentile_disc(0.2) within group(order by col6, col2) p_disc from p_disc group by col3 order by 1, 2;
select col4, col5, percentile_disc(0.3) within group(order by col3, col4, col5, col6, col7) p_disc from p_disc group by col4, col5 order by 1, 2;
select col4, col5, percentile_disc(0.3) within group(order by 2, 1, 3) p_disc from p_disc group by col4, col5 order by 1, 2;


drop table p_disc;




