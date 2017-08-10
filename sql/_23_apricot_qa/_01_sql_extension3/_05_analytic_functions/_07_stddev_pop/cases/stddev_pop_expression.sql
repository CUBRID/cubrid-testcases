--using single/multiple expressions in partition by and order by clause


create table stddev_pop_expression(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into stddev_pop_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into stddev_pop_expression(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into stddev_pop_expression(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into stddev_pop_expression(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into stddev_pop_expression(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: using single expression in partition by clause
select col1, stddev_pop(col1) over(partition by 100) stddev_pop from stddev_pop_expression order by 1, 2;
select col2, stddev_pop(all col2) over(partition by null) stddev_pop from stddev_pop_expression order by 1, 2;
select col1, col2, stddev_pop(distinct col1) over(partition by col1+col2) stddev_pop from stddev_pop_expression order by 1, 2, 3;
select col1, col2, col3, stddev_pop(unique col2) over(partition by left(col3, 3)), col3 from stddev_pop_expression order by 1, 2, 3, 4;
select col1, col2, col4, stddev_pop(distinctrow col1) over(partition by adddate(col4, 12)) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;


--TEST: using multiple expressions in partition by clause
select col3, col1, col2, stddev_pop(col1) over(partition by col3, col2) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;
select col4, col1, col2, clob_to_char(col5), stddev_pop(col2) over(partition by col4, clob_to_char(col5)) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;
select col3, col4, stddev_pop(unique col1) over(partition by col1, col2, col3, col4) stddev_pop from stddev_pop_expression order by 1, 2, 3;
select col3, col4, stddev_pop(distinct col2) over(partition by SYSDATE, round(col2, 0)) stddev_pop from stddev_pop_expression order by 1, 2, 3;
select col3, col4, clob_to_char(col5), stddev_pop(all col2) over(partition by col1-col2, col2-col1) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;


--TEST: using expressions in order by clause
select col1, stddev_pop(col1) over(order by col1*col2) stddev_pop from stddev_pop_expression order by 1, 2;
select col2, stddev_pop(col2) over(order by round((col2/col1+col1), 0)) stddev_pop from stddev_pop_expression order by 1, 2;
select col1, col2, col3, stddev_pop(distinctrow col2) over(order by upper(col3)) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;
select col1, col2, col4, stddev_pop(all col1) over(order by last_day(col4)), col3 from stddev_pop_expression order by 1, 2, 3, 4;
select col1, col2, clob_to_char(col5), stddev_pop(unique col1) over(order by char_length(clob_to_char(col5))) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;



--TEST: using expressions in both partition by and order by clause
select col3, col1, col2, stddev_pop(col2) over(partition by col3, col2 order by col1*col2) stddev_pop from stddev_pop_expression order by 1,2, 3, 4;
select col4, col1, col2, clob_to_char(col5), stddev_pop(col1) over(partition by col4, clob_to_char(col5) order by col1, col2) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;
select col3, col4, stddev_pop(all col1) over(partition by right(col3, 2) order by subdate(col4, 12)) stddev_pop from stddev_pop_expression order by 1, 2, 3;
select col3, col4, stddev_pop(distinct col2) over(partition by SYSDATE, round(col2, 0) order by upper(clob_to_char(col5))) stddev_pop from stddev_pop_expression order by 1, 2, 3;
select col3, col4, clob_to_char(col5), stddev_pop(unique col1) over(partition by col1-col2, col2-col1 order by trunc((col2/col1), 2)) stddev_pop from stddev_pop_expression order by 1, 2, 3, 4;



delete from stddev_pop_expression;
drop table stddev_pop_expression;


