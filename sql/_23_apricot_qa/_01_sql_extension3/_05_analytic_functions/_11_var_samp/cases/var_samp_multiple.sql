--use multiple analytic functions in one statement
--nested analytic functions


create table var_samp_multi(
	col1 int auto_increment primary key,
	col2 float not null,
	col3 char(20) default 'abc',
	col4 datetime default SYS_DATETIME,
	col5 bit varying
);


insert into var_samp_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'0001');
insert into var_samp_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:23:34.123', B'0010');
insert into var_samp_multi(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:23:34.123', B'0100');
insert into var_samp_multi(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:23:34.123', B'1000');
insert into var_samp_multi(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:23:34.123', B'0011');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:23:34.123', B'0101');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:23:34.123', B'1001');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:23:34.123', B'0110');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:23:34.123', B'1010');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:23:34.123', B'1100');
insert into var_samp_multi(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:23:34.123', B'0111');
insert into var_samp_multi(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into var_samp_multi(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:23:34.123', B'1111');
insert into var_samp_multi(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:23:34.123', B'1010');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:23:34.123', B'0101');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'1110');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:23:34.123', B'0111');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:23:34.123', B'1101');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:23:34.123', B'0011');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:23:34.123', B'0001');
insert into var_samp_multi(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:23:34.123', B'1100');
insert into var_samp_multi(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:23:34.123', B'1011');
insert into var_samp_multi(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:23:34.123', null);
insert into var_samp_multi(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:23:34.123', B'0110');
insert into var_samp_multi(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:23:34.123', '');
insert into var_samp_multi(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:23:34.123', B'1111');
insert into var_samp_multi(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:23:34.123', B'0100');
insert into var_samp_multi(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:23:34.123', null);
insert into var_samp_multi(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:23:34.123', B'1111');




--TEST: 2 analytic functions with over() clause in one statement
select *, var_samp(col1) over() var_samp1, var_samp(col2) over() var_samp2 from var_samp_multi order by col1;
select *, var_samp(col2) over() var_samp1, var_samp(distinct col1) over() var_samp2 from var_samp_multi order by 6, col1;


--TEST: 2 analytic functions with over(partition by) clause in one statement
select *, var_samp(col1) over(partition by col3), var_samp(col2) over(partition by col5) from var_samp_multi order by col2, col1;
select *, var_samp(col2) over(partition by col1, col3) var_samp1, var_samp(distinct col1) over(partition by col2, col5) var_samp2 from var_samp_multi order by col3, col4, var_samp2;


--TEST: 3 analytic functions with over(order by) clause in one statement
select col1, col2, col3, var_samp(col2) over(order by col1) var_samp1, var_samp(unique col1) over(order by col2) var_samp2, var_samp(all col1) over(order by col3, col4) var_samp3 from var_samp_multi order by col3, col2, var_samp3;
select *, var_samp(col2) over(order by col3 asc, col5 desc) var_samp1, var_samp(distinct col1) over(order by col2, col3) var_samp2, var_samp(all col2) over(order by col4) from var_samp_multi order by col5 asc, col3 desc;


--TEST: 2 analytic functions with over(partition by ... order by ...) clause in one statement
select *, var_samp(all col1) over(partition by col3 order by col1) var_samp1, var_samp(distinctrow col2) over(partition by col1, col4 order by col3) var_samp2 from var_samp_multi order by col3;
select *, var_samp(col2) over(partition by col4 order by col4, col1 desc) var_samp1, var_samp(col1) over(partition by col3 order by col1) var_samp2 from var_samp_multi order by var_samp(distinct col2) over(partition by col5 order by col1 desc);


--TEST: nested analytic functions
select col1, col2, var_samp(col1) over(partition by col1 order by var_samp(col2) over()) from var_samp_multi order by col2 desc, col1;
select col5, col2, col4, var_samp(unique col2) over(partition by var_samp(all col1) over(order by col5) order by col4, col2, col5) from var_samp_multi order by 4, 3 desc, 2 asc, 1;
 


drop table var_samp_multi;


