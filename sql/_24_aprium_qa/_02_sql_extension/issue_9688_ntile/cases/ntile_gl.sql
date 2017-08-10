--combination with limit clause and prepare statement


create table ntile_gl(
	col1 smallint auto_increment primary key,
	col2 bigint,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into ntile_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 18:19:29', B'0001');
insert into ntile_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 18:19:29', B'0010');
insert into ntile_gl(col2, col3, col4, col5) values(500, null, '1990-10-11 18:19:29', B'0100');
insert into ntile_gl(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 18:19:29', B'1000');
insert into ntile_gl(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 18:19:29', B'0011');
insert into ntile_gl(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 18:19:29', B'0101');
insert into ntile_gl(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 18:19:29', B'1001');
insert into ntile_gl(col2, col3, col4, col5) values(null, 'oracle', '1990-11-10 18:19:29', B'0110');
insert into ntile_gl(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 18:19:29', B'1010');
insert into ntile_gl(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 18:19:29', B'1100');
insert into ntile_gl(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 18:19:29', B'0111');
insert into ntile_gl(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 18:19:29', B'1110');
insert into ntile_gl(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 18:19:29', B'1111');
insert into ntile_gl(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 18:19:29', B'1010');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 18:19:29', B'0101');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 18:19:29', B'1110');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 18:19:29', B'0111');
insert into ntile_gl(col2, col3, col4, col5) values(503, null, '1993-11-10 18:19:29', B'1101');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 18:19:29', B'0011');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 18:19:29', B'0001');
insert into ntile_gl(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 18:19:29', B'1100');
insert into ntile_gl(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 18:19:29', B'1011');
insert into ntile_gl(col2, col3, col4, col5) values(null, 'mysql', '1990-10-10 18:19:29', null);
insert into ntile_gl(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 18:19:29', B'0110');
insert into ntile_gl(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 18:19:29', '');
insert into ntile_gl(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 18:19:29', B'1111');
insert into ntile_gl(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 18:19:29', B'0100');
insert into ntile_gl(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 18:19:29', null);
insert into ntile_gl(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 18:19:29', B'1111');




--TEST: group by clause
select ntile(5) over() b_num from ntile_gl group by col2 order by 1;
select ntile(6) over(order by col2) from ntile_gl where col1 > 10 group by col2 order by 1;
select ntile(4) over(partition by col3) from ntile_gl group by col3, col4 order by 1;
select ntile(10) over(partition by col1 order by col5, col4) from ntile_gl group by col4 order by 1;


--TEST: having clause
select ntile(5) over() b_num from ntile_gl group by col2 having col1 < 22 order by 1;
select ntile(6) over(order by col2) from ntile_gl where col1 > 10 group by col2 having col3='mysql' order by 1;
select ntile(4) over(partition by col3) from ntile_gl group by col3, col4 having year(col4) > 1991 order by 1;
select ntile(10) over(partition by new.col1 order by new.col5, new.col4) from (select * from ntile_gl order by 1,2,3,4,5) new group by new.col4 having new.col1 > 3 order by 1;

--TEST: limit clause
select ntile(8) over() b_num from ntile_gl where col3 in ('cubrid', 'oracle') limit 10;
select ntile(3.3) over(partition by col2) b_num from ntile_gl order by 1 limit 3;


--TEST: group by + limit
select ntile(6) over(partition by col3 order by col1) from (select * from ntile_gl order by 1,2,3,4,5) group by col2 order by col1 limit 10;
select ntile(5) over(partition by col4 order by col1) b_num from ntile_gl group by col4 order by col1, b_num limit 2;


--TEST: [er] use width_bucket function in group by clause
select ntile(10) over(partition by col1 order by col5, col4) from ntile_gl group by ntile(10) over(partition by col1 order by col5, col4) order by 1;
--TEST: [er] use width_bucket function in having clause
select ntile(5) over() b_num from ntile_gl group by col2 having ntile(5) over() < 10 order by 1;
--TEST: use width_bucket function in where clause
select ntile(6) over(order by col2) from ntile_gl where ntile(6) over(order by col2) > 3 order by 1;
select ntile(10) over(partition by col1 order by col5, col4) from ntile_gl where ntile(3) over(order by col3) > 2 group by col4 order by 1;
--TEST: use width_bucket function in order by clause
select ntile(8) over() b_num from ntile_gl where col3 in ('cubrid', 'oracle') order by ntile(8) over(), 1;
select ntile(5) over(partition by col4 order by col1) b_num from ntile_gl group by col4 order by ntile(10) over(partition by col1 order by col5, col4), 1;




drop table ntile_gl;


