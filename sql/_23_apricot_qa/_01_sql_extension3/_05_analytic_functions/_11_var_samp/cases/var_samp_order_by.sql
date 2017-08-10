--combination with order by clause


create table var_samp_orderby(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into var_samp_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'0001');
insert into var_samp_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', B'0010');
insert into var_samp_orderby(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', B'0100');
insert into var_samp_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', B'1000');
insert into var_samp_orderby(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', B'0011');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', B'0101');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', B'1001');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', B'0110');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', B'1010');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', B'1100');
insert into var_samp_orderby(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', B'0111');
insert into var_samp_orderby(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', B'1110');
insert into var_samp_orderby(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', B'1111');
insert into var_samp_orderby(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', B'1010');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', B'0101');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'1110');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', B'0111');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', B'1101');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', B'0011');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', B'0001');
insert into var_samp_orderby(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', B'1100');
insert into var_samp_orderby(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', B'1011');
insert into var_samp_orderby(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into var_samp_orderby(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', B'0110');
insert into var_samp_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into var_samp_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', B'1111');
insert into var_samp_orderby(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', B'0100');
insert into var_samp_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into var_samp_orderby(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', B'1111');




--TEST: over() clause + order by
select *, var_samp(col1) over() var_samp from var_samp_orderby order by 1, 2, 3, 4, 5, 6;
select *, var_samp(col2) over() var_samp from var_samp_orderby order by 6, col1;
select col1, col2, col3, col4, var_samp(col2) over() var_samp from var_samp_orderby order by 1, col2, col3, 4, 5;


--TEST: over(partition by) clause + order by
select *, var_samp(distinct col1) over(partition by col3) from var_samp_orderby order by 1, 2, 3, 4, 5, 6;
select *, var_samp(all col2) over(partition by col4) var_samp from var_samp_orderby order by 1, 2, 3, 4, 5, 6;
select col3, col4, var_samp(unique col1) over(partition by col4) var_samp from var_samp_orderby order by 1, 2, 3;
select col3, col4, var_samp(distinctrow col2) over(partition by col3) from var_samp_orderby order by 1, 2, 3;


--TEST: over(order by) clause + order by
select col1, col2, col3, var_samp(col1) over(order by col1) var_samp from var_samp_orderby order by 1, 2, 3, 4;
select col2, var_samp(col2) over(order by col2) var_samp, col3 from var_samp_orderby order by 1, 2, 3;
select *, var_samp(col2) over(order by col3 asc, col5 desc) from var_samp_orderby order by 1, 2, 3, 4, 5, 6;
select *, var_samp(unique col1) over(order by col1, col2, col3 desc, col4, col5), col3 from var_samp_orderby order by 6, 5 desc, 4, 3, 2, 1;
select col1, col2, var_samp(all col1) over(order by col2) from var_samp_orderby order by 1, 2, 3;


--TEST: over(partition by.. order by ..) clause + order by
select *, var_samp(col1) over(partition by col3 order by col1) from var_samp_orderby order by 1, 2, 3, 4, 5, 6;
select *, var_samp(col2) over(partition by col4 order by col4, col1 desc) var_samp from var_samp_orderby order by col1;
select col1, col3, col4, var_samp(distinct col1) over(partition by col4 order by col3, col2, col1 desc) var_samp from var_samp_orderby order by 1, 2, 3, 4;
select col3, col4, col2, var_samp(unique col2) over(partition by col3 order by col4) from var_samp_orderby order by 1, 2, 3, 4;
select col3, col4, col5, var_samp(col1) over(partition by col4 order by col3, col2) from var_samp_orderby order by 1, 2, 4 desc, 3 asc;


--TEST: over(partition by.. order by ..) clause + order by ... having ...
--select col1, col2, var_samp(col1) over(partition by col1 order by col2) from var_samp_orderby group by col1 having col1 > 500 order by col2 desc, col1;
--select col5, col2, col4, var_samp(col2) over(partition by col4 order by col4, col2, col5) from var_samp_orderby group by col4 having right(clob_to_char(col5), 4) =  '.com' order by 4, 3 desc, 2 asc, 1;
--select col1, col2, col3, col4, col5, var_samp(distinct col2) over(partition by col3 order by col2 desc, col4, col5) from var_samp_orderby group by col1, col2, col3, col4 having col2 in ('cubrid', 'mysql') and right(clob_to_char(col5), 12) = '@domainname.com' order by col3 desc, col2 asc, 6, 1;
 



drop table var_samp_orderby;


