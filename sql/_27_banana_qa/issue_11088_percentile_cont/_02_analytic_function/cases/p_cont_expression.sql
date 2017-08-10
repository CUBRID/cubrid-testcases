--using single/multiple expressions in partition by and order by clause

drop table if exists p_cont_expression;
create table p_cont_expression(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into p_cont_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into p_cont_expression(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into p_cont_expression(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into p_cont_expression(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into p_cont_expression(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: using single expression in partition by clause
select col1, percentile_cont(0.1) within group (order by col1) over(partition by 100) p_cont from p_cont_expression;
select col1, percentile_cont(0.9) within group (order by col1) over(partition by 2) p_cont from p_cont_expression;
select col2, percentile_cont(0.2) within group (order by col2) over(partition by -3) p_cont from p_cont_expression order by 1, 2;
select col4, percentile_cont(1) within group (order by col4) over(partition by null) p_cont from p_cont_expression order by 1, 2;
select col2, percentile_cont(0) within group (order by col4 desc) over(partition by 'a') p_cont from p_cont_expression order by 1, 2;
select col1, col2, col1+col2, percentile_cont(0.3) within group (order by col1) over(partition by col1+col2) p_cont from p_cont_expression order by 1, 2, 3, 4;
select col1, col2, left(col3, 3), percentile_cont(0.6) within group (order by col2) over(partition by left(col3, 3)) p_cont, col3 from p_cont_expression order by 1, 2, 3, 4;
select adddate(col4, 12), percentile_cont(0.8) within group (order by col1) over(partition by adddate(col4, 12)) p_cont, col4 from p_cont_expression order by 1, 2, 3;
select col1, incr(col2), percentile_cont(0.8) within group (order by col1) over(partition by incr(col2)) p_cont, col4 from p_cont_expression order by 1, 2, 3, 4;


--TEST: using multiple expressions in partition by clause
select col3, col2, percentile_cont(0.1) within group (order by col1) over(partition by col3, col2) p_cont from p_cont_expression order by 1, 2, 3;
select col4, col1, col2, clob_to_char(col5), percentile_cont(0.3) within group (order by col2) over(partition by col4, clob_to_char(col5)) p_cont from p_cont_expression order by 1, 2, 3, 4, 5;
select col3, col4, percentile_cont(0.7) within group (order by col1) over(partition by col3, col4) p_cont from p_cont_expression order by 1, 2, 3;
select col3, col4, percentile_cont(0.9) within group (order by col2) over(partition by SYSDATE, round(col1, 0)) p_cont from p_cont_expression order by 1, 2, 3;
select col2, col1-col2, col2-col1, percentile_cont(0.87) within group (order by col2) over(partition by col1-col2, col2-col1) p_cont, col1 from p_cont_expression order by 1, 2, 3, 4;


--TEST: using expressions in the first param 
select col1, percentile_cont(-1) within group (order by col1) over(partition by col3) from p_cont_expression order by 1, 2;
select col1, percentile_cont(1000) within group (order by col1) over(partition by col3) from p_cont_expression order by 1, 2;
select col1, percentile_cont(null) within group (order by col1) over(partition by col3) from p_cont_expression order by 1, 2;
select col1, percentile_cont('a') within group (order by col1) over(partition by col3) from p_cont_expression order by 1, 2;
select col1, percentile_cont(abs(col1)) within group (order by col2 desc) over(partition by col3) from p_cont_expression order by 1, 2;
select col1, percentile_cont(decr(col2)) within group (order by col1) over(partition by col3) from p_cont_expression order by 1, 2;


--TEST: using expressions in the second param
select col1, col1*col2, percentile_cont(0.1) within group (order by col1*col2) over(partition by col4) p_cont from p_cont_expression order by 1, 2;
select col2, round((col2/col1+col1), 0) aaa, percentile_cont(0.34) within group (order by round((col2/col1+col1), 0)) over(partition by clob_to_char(col5)) p_cont from p_cont_expression order by 1, 2;
select col2, col4, last_day(col4), percentile_cont(0.5) within group (order by last_day(col4) desc) over(partition by col2) p_cont, col3 from p_cont_expression order by 1, 2, 3, 4, 5;
select col1, col2, clob_to_char(col5), percentile_cont(0.7) within group (order by char_length(clob_to_char(col5))) over(partition by col4) p_cont from p_cont_expression order by 1, 2, 3, 4;



delete from p_cont_expression;
drop table p_cont_expression;


