--TEST: pass numeric type values to the first param

drop table if exists p_cont;

create table p_cont(
	col1 int,
	col2 short, 
	col3 bigint,
	col4 numeric(10, 5),
	col5 float,
	col6 double,
	col7 monetary
);


insert into p_cont values(0.1, 0.2, 0.01, 0.06789, 0.11, 0.130, 0.55);
insert into p_cont values(0.1, 0.4, 0.02, 0.06789, 0.12, 0.129, 0.55);
insert into p_cont values(0.1, 0.2, 0.03, 0.16789, 0.13, 0.128, 0.55);
insert into p_cont values(0.1, 0.4, 0.04, 0.06789, 0.14, 0.127, 0.55);
insert into p_cont values(0.1, 0.2, 0.05, 0.16789, 0.15, 0.126, 0.55);
insert into p_cont values(0.3, 0.4, 0.07, 0.06789, 0.16, 0.125, 0.55);
insert into p_cont values(0.3, 0.2, 0.08, 0.06789, 0.17, 0.124, 0.55);
insert into p_cont values(0.3, 0.2, 0.01, 0.26789, 0.18, 0.123, 0.55);
insert into p_cont values(0.3, 0.6, 0.02, 0.06789, 0.19, 0.122, 0.55);
insert into p_cont values(0.5, 0.2, 0.03, 0.06789, 0.20, 0.121, 0.55);
insert into p_cont values(0.5, 0.2, 0.04, 0.16789, 0.21, 0.120, 0.55);
insert into p_cont values(0.5, 0.6, 0.05, 0.06789, 0.23, 0.119, 0.55);
insert into p_cont values(0.7, 0.2, 0.01, 0.06789, 0.24, 0.118, 0.55);
insert into p_cont values(0.9, 0.2, 0.02, 0.06789, 0.25, 0.117, 0.55);
insert into p_cont values(0.9, 0.4, 0.03, 0.06789, 0.26, 0.116, 0.55);
insert into p_cont values(0.9, 0.2, 0.04, 0.56789, 0.27, 0.115, 0.55);
insert into p_cont values(0.9, 0.2, 0.05, 0.06789, 0.28, 0.114, 0.55);
insert into p_cont values(0.9, 0.6, 0.06, 0.56789, 0.29, 0.113, 0.55);
insert into p_cont values(0.9, 0.2, 0.07, 0.06789, 0.30, 0.112, 0.55);
insert into p_cont values(0.9, 0.2, 0.08, 0.56789, 0.31, 0.111, 0.55);


--test: pass constant values to the first param
select col2, percentile_cont(0) within group(order by col1) p_cont from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(1) within group(order by col1) p_cont from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.5) within group(order by col1) p_cont from p_cont group by col2 order by 1, 2;
select col2, percentile_cont(0.8888888) within group(order by col1) p_cont from p_cont group by col2 order by 1, 2;
--test: [er] out-of-range values
select col2, percentile_cont(1.1) within group(order by col1) from p_cont group by col2;
select col2, percentile_cont(-0.5) within group(order by col1) from p_cont group by col2;
select col2, percentile_cont(100000000) within group(order by col1) from p_cont group by col2;
select col2, percentile_cont(-999) within group(order by col1) from p_cont group by col2;

--test: pass numeric type columns to the first param
select col2, percentile_cont(col1) within group(order by col1) from (select col2, col1 from p_cont order by 1, 2) group by col2 order by 1, 2;
select col2, percentile_cont(col2) within group(order by col1) from (select col2, col1 from p_cont order by 1, 2) group by col2 order by 1, 2;
select col2, percentile_cont(col3) within group(order by col1) from (select col2, col3, col1 from p_cont order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_cont(col4) within group(order by col1) from (select col2, col4, col1 from p_cont order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_cont(col5) within group(order by col1) from (select col2, col5, col1 from p_cont order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_cont(col6) within group(order by col1) from (select col2, col6, col1 from p_cont order by 1, 2, 3) group by col2 order by 1, 2;
select col2, percentile_cont(col7) within group(order by col1) from (select col2, col7, col1 from p_cont order by 1, 2, 3) group by col2 order by 1, 2;


drop table p_cont;




