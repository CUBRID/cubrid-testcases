--use multiple analytic functions in one statement
--nested analytic functions

drop table if exists p_cont_multi;
create table p_cont_multi(
	col1 int auto_increment primary key,
	col2 float not null,
	col3 char(20) default 'abc',
	col4 datetime default SYS_DATETIME,
	col5 bit varying
);


insert into p_cont_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'0001');
insert into p_cont_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:23:34.123', B'0010');
insert into p_cont_multi(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:23:34.123', B'0100');
insert into p_cont_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'1000');
insert into p_cont_multi(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:23:34.123', B'0011');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:23:34.123', B'0101');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:23:34.123', B'1001');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:23:34.123', B'0110');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:23:34.123', B'1010');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:23:34.123', B'1100');
insert into p_cont_multi(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:23:34.123', B'0111');
insert into p_cont_multi(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into p_cont_multi(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:23:34.123', B'1111');
insert into p_cont_multi(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:23:34.123', B'1010');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:23:34.123', B'0101');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'0111');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:23:34.123', B'1101');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:23:34.123', B'0011');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:23:34.123', B'0001');
insert into p_cont_multi(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:23:34.123', B'1100');
insert into p_cont_multi(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:23:34.123', B'1011');
insert into p_cont_multi(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:23:34.123', null);
insert into p_cont_multi(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:23:34.123', B'0110');
insert into p_cont_multi(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:23:34.123', '');
insert into p_cont_multi(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:23:34.123', B'1111');
insert into p_cont_multi(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:23:34.123', B'0100');
insert into p_cont_multi(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:23:34.123', null);
insert into p_cont_multi(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:23:34.123', B'1111');




--TEST: 2 analytic functions with over() clause in one statement
select col1, percentile_cont(0.1) within group (order by col1) over() p_cont1, percentile_cont(0.3) within group (order by col2) over() p_cont2 from p_cont_multi order by col1;
select col1, percentile_cont(0.2) within group (order by col2) over() p_cont1, percentile_cont(0.3) within group (order by col1) over() p_cont2 from p_cont_multi order by col1;


--TEST: 2 analytic functions with over(partition by) clause in one statement
select col2, col1, percentile_cont(0.4) within group (order by col1) over(partition by col3) p_cont1, percentile_cont(0.7) within group (order by col2) over(partition by col5) p_cont2 from p_cont_multi order by col2, col1;
select col3, col4, percentile_cont(0.5) within group (order by col2) over(partition by col1, col3) p_cont1, percentile_cont(0.6) within group (order by col1) over(partition by col2, col5) p_cont2 from p_cont_multi order by col3, col4, p_cont2;


--TEST: 3 analytic functions with over(partition by) clause in one statement
select col1, col2, col3, percentile_cont(0.1) within group (order by col2) over(partition by col1) p_cont1, percentile_cont(0.2) within group (order by col1) over(partition by col2) p_cont2, percentile_cont(0.3) within group (order by col1) over(partition by col3, col4) p_cont3 from p_cont_multi order by col3, col2, p_cont3;



--TEST: nested analytic functions
select col1, col2, percentile_cont(0.3) within group (order by col1 desc) over(partition by percentile_cont(0.8) within group (order by col2) over()) from p_cont_multi order by col2 desc, col1;
select col5, col2, col4, percentile_cont(0.33) within group (order by col2 asc) over(partition by percentile_cont(0.65) within group (order by col1) over(partition by col5)) p_cont from p_cont_multi order by 4, 3 desc, 2 asc, 1;
 


drop table p_cont_multi;


