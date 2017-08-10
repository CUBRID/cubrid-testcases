--use analytic function in a subquery


create table c_subquery(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into c_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into c_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into c_subquery(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into c_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into c_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into c_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into c_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into c_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into c_subquery(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into c_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into c_subquery(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into c_subquery(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into c_subquery(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into c_subquery(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into c_subquery(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into c_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into c_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into c_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into c_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into c_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into c_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into c_subquery(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into c_subquery(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into c_subquery(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into c_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into c_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into c_subquery(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into c_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into c_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');



--TEST: analytic function in a subquery as a select expression
select (select count(distinct col2) over(partition by col1) from c_subquery where col1=10) from c_subquery;
--TEST: 2 tables
create table t(id int, str char(20));
insert into t values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into t values(11, 'aaa'), (12, 'bbb'), (13, 'ccc'), (14, 'ddd'), (15, 'eee'), (16, 'fff');
--TEST: analytic function in a subquery as a select expression
select c.col1, c.col3, (select count(*) over(partition by t.str order by t.id) from t t where c.col1=t.id), c.col4, c.col5 from c_subquery c order by 1, 2, 3, 4, 5;
--TEST: Write a sub-query in the select list of the outer query, and in the sub-query attempt use of analytic functions over the outer query
--????



--TEST: Use analytic functions in a subquery used as a table specification for the outer query
select col1, col2, cnt, col3 from (select *, count(col1) over(partition by col2 order by col1) cnt from c_subquery);
--TEST: Use analytic functions in a subquery used as a table specification for the outer query, use the return result in the outer query
select col1, col2, cnt, col3 from (select *, count(col1) over(partition by col2 order by col1) cnt from c_subquery) where cnt > 5;


--TEST: use analytic functions in where clause
--TEST: combination with comparison operators

--TEST: combination with =
select col1, col2, col3, col4 from c_subquery where col1 = (select count(*) over(partition by str) cnt from t order by str limit 1);
--TEST: combination with <
select col1, col2, col3, col4 from c_subquery where col1 < (select max(cnt) from (select count(all id) over(partition by id order by str) cnt from t order by str));
--TEST: combination with >=, self-contained
select col1, col2, col3, col4 from c_subquery where col1 >= (select count(distinct col2) over(partition by col3) cnt from c_subquery where col1=15);

--TEST: combination with in
select col1, col3, col5 from c_subquery where col1 in (select count(*) over(partition by str) cnt from t order by str); 
--TEST: combination with any
select col1, col3, col5 from c_subquery where col1 = any(select count(all id) over(partition by str) cnt from t); 
--TEST: combination with exists, use analytic functions in a correlated subquery
select col1, col3, col5 from c_subquery c where exists (select count(*) over(partition by str) cnt from t where t.id=c.col1) order by 1, 2, 3;  





drop table c_subquery;
drop table t;

