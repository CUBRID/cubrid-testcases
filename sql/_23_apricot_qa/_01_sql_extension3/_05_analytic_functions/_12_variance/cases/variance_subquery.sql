--use analytic function in a subquery


create table variance_subquery(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into variance_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into variance_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into variance_subquery(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into variance_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into variance_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into variance_subquery(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into variance_subquery(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into variance_subquery(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into variance_subquery(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into variance_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into variance_subquery(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into variance_subquery(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into variance_subquery(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into variance_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into variance_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into variance_subquery(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into variance_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into variance_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');



--TEST: analytic function in a subquery as a select expression
select (select variance(distinct col2) over(partition by col1) from variance_subquery where col1=10) from variance_subquery order by 1;
--TEST: 2 tables
create table test(id int, str char(20));
insert into test values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into test values(11, 'aaa'), (12, 'bbb'), (13, 'ccc'), (14, 'ddd'), (15, 'eee'), (16, 'fff');
--TEST: analytic function in a subquery as a select expression
select c.col1, c.col3, (select variance(t.id) over(partition by t.str order by t.id) from test t where c.col1=t.id), c.col4, c.col5 from variance_subquery c order by 1, 2, 3;
--TEST: Write a sub-query in the select list of the outer query, and in the sub-query attempt use of analytic functions over the outer query
--????



--TEST: Use analytic functions in a subquery used as a table specification for the outer query
select col1, col2, variance, col3 from (select *, variance(col1) over(partition by col2 order by col1) variance from variance_subquery) order by 1, 2, 3, 4;
--TEST: Use analytic functions in a subquery used as a table specification for the outer query, use the return result in the outer query
select col1, col2, variance, col3 from (select *, variance(distinct col1) over(partition by col2 order by col1) variance from variance_subquery) where variance > 5 order by 1,2, 3, 4;


--TEST: use analytic functions in where clause
--TEST: combination with comparison operators

--TEST: combination with =
select col1, col2, col3, col4 from variance_subquery where col1 = (select variance(distinct col2) over(partition by str) variance from test order by str limit 1) order by 1, 2, 3, 4;
--TEST: combination with <
select col1, col2, col3, col4 from variance_subquery where col1 < (select max(variance) from (select variance(all id) over(partition by id order by str) variance from test order by str)) order by 1, 2, 3, 4;
--TEST: combination with >=, self-contained
select col1, col2, col3, col4 from variance_subquery where col1 >= (select variance(distinct col2) over(partition by col3) variance from variance_subquery where col1=15) order by 1, 2, 3, 4;

--TEST: combination with in
select col1, col3, col5 from variance_subquery where col1 in (select variance(distinct id) over(partition by str) variance from test order by str) order by 1, 2, 3;  
--TEST: combination with any
select col1, col3, col5 from variance_subquery where col1 = any (select variance(all id) over(partition by str) variance from test) order by 1, 2, 3; 
--TEST: combination with exists, use analytic functions in a correlated subquery
select col1, col3, col5 from variance_subquery c where exists (select variance(distinct id) over(partition by str) variance from test t where t.id=c.col1) order by 1, 2, 3;  




drop table test;
drop table variance_subquery;


