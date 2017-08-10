--using single/multiple expressions in partition by and order by clause


create table max_expression(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into max_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into max_expression(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into max_expression(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into max_expression(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into max_expression(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: using single expression in partition by clause
select col1, max(col1) over(partition by 100) maximum from max_expression order by 1, 2;
select col2, max(all col2) over(partition by null) maximum from max_expression order by 1, 2;
select col1, col2, max(distinct col3) over(partition by col1+col2) maximum from max_expression order by 1, 2, 3;
select col1, col2, col3, max(unique col4) over(partition by left(col3, 3)), col3 from max_expression order by 1, 2, 3, 4;
select col1, col2, col4, max(unique clob_to_char(col5)) over(partition by adddate(col4, 12)) maximum from max_expression order by 1, 2, 3, 4;


--TEST: using multiple expressions in partition by clause
select col3, col1, col2, max(col1) over(partition by col3, col2) maximum from max_expression order by 1, 2, 3, 4;
select col4, col1, col2, clob_to_char(col5), max(col2) over(partition by col4, clob_to_char(col5)) maximum from max_expression order by 1, 2, 3, 4, 5;
select col3, col4, max(unique col3) over(partition by col1, col2, col3, col4) maximum from max_expression order by 1, 2, 3;
select col3, col4, max(distinct col4) over(partition by SYSDATE, round(col2, 0)) maximum from max_expression order by 1, 2, 3;
select col3, col4, clob_to_char(col5), max(all clob_to_char(col5)) over(partition by col1-col2, col2-col1) maximum from max_expression order by 1, 2, 3, 4;


--################# CUBRID BUG ##########################
--TEST: select expressions and analytic function together
select col1, col2, col1+col2, max(col3) over() from max_expression order by 1, 2, 3, 4;
select col2, col1+col2, max(col3) over() from max_expression order by 1, 2, 3;
select col1, col1+col2, max(col3) over() from max_expression order by 1, 2, 3;
select col1+col2, max(col3) over() from max_expression order by 1, 2;

select col1, col4, adddate(col4, col1), max(col2) over(partition by col4) from max_expression order by 1, 2, 3, 4;
select col4, adddate(col4, col1), max(col2) over(partition by col4) from max_expression order by 1, 2, 4;
select col1, adddate(col4, col1), max(col2) over(partition by col4) from max_expression order by 1, 2, 4;
select adddate(col4, col1), max(col2) over(partition by col4) from max_expression order by 1, 2;


--TEST: using expressions in order by clause
select col1*col2, max(col1) over(order by col1*col2) maximum from max_expression order by 1, 2;
select col2, round((col2/col1+col1), 0), max(col2) over(order by round((col2/col1+col1), 0)) maximum from max_expression order by 1, 2, 3;
select col1, col2, upper(col3), max(unique col3) over(order by upper(col3)) maximum from max_expression order by 1, 2, 3, 4;
select col1, col2, col4, max(all col4) over(order by last_day(col4)), col3 from max_expression order by 1, 2, 3, 4;
select col1, col2, clob_to_char(col5), max(unique clob_to_char(col5)) over(order by char_length(clob_to_char(col5))) maximum from max_expression order by 1, 2, 3, 4;



--TEST: using expressions in both partition by and order by clause
select col3, col1, col2, max(col1) over(partition by col3, col2 order by col1*col2) maximum from max_expression order by 1, 2, 3, 4;
select col4, col1, col2, clob_to_char(col5), max(col2) over(partition by col4, clob_to_char(col5) order by col1, col2) maximum from max_expression order by 1, 2, 3, 4, 5;
select col3, col4, max(all col4) over(partition by right(col3, 2) order by subdate(col4, 12)) maximum from max_expression order by 1, 2, 3;
select col3, col4, max(distinct col3) over(partition by SYSDATE, round(col2, 0) order by upper(clob_to_char(col5))) maximum from max_expression order by 1, 2, 3;
select col3, col4, clob_to_char(col5), max(unique clob_to_char(col5)) over(partition by col1-col2, col2-col1 order by trunc((col2/col1), 2)) maximum from max_expression order by 1, 2, 3, 4;



delete from max_expression;
drop table max_expression;


