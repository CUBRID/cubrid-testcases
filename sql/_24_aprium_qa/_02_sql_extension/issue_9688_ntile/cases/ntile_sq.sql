--use ntile function in a subquery


create table ntile_sq(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into ntile_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into ntile_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into ntile_sq(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into ntile_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into ntile_sq(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into ntile_sq(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into ntile_sq(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into ntile_sq(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into ntile_sq(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into ntile_sq(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into ntile_sq(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into ntile_sq(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into ntile_sq(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into ntile_sq(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into ntile_sq(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into ntile_sq(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into ntile_sq(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into ntile_sq(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');



--TEST: ntile function in a subquery as a select expression
select (select ntile(5) over(partition by col1 order by col2, col5) from ntile_sq where col1=10) aaa from ntile_sq;
--TEST: 2 tables
create table t(id int, str char(20));
insert into t values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into t values(11, 'aaa'), (12, 'bbb'), (13, 'ccc'), (14, 'ddd'), (15, 'eee'), (16, 'fff');
--TEST: ntile function in a subquery as a select expression
select c.col1, c.col3, (select ntile(5) over(partition by t.str order by t.id) from t where c.col1=t.id) rn, c.col4, c.col5 from ntile_sq c order by 1, 2, 3, 4, 5;



--TEST: Use ntile functions in a subquery used as a table specification for the outer query
select b_num from (select ntile(5) over() b_num from ntile_sq) order by 1;
select col1, col2, b_num, col3 from (select *, ntile(5) over(partition by col2 order by col1) b_num from ntile_sq);
--TEST: Use ntile functions in a subquery used as a table specification for the outer query, use the return result in the outer query
select col1, col2, b_num, col3 from (select *, ntile(5) over(partition by col2 order by col1) b_num from ntile_sq) where b_num > 2;


--TEST: use ntile functions in where clause
--TEST: combination with comparison operators

--TEST: combination with =
select col1, col2, col3, col4 from ntile_sq where col1 = (select ntile(5) over(partition by str order by id) b_num from t order by str limit 1);
--TEST: combination with <
select col1, col2, col3, col4 from ntile_sq where col1 < (select max(b_num) from (select ntile(5) over(order by id desc) b_num from t order by str));
--TEST: combination with >=, self-contained
select col1, col2, col3, col4 from ntile_sq where col1 >= (select ntile(7) over(partition by col3 order by col1) b_num from ntile_sq where col1=15);

--TEST: combination with in
select col1, col3, col5 from ntile_sq where col1 in (select ntile(5) over(partition by col2 order by col1) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 in (select ntile(5) over(partition by col2) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 in (select ntile(5) over(partition by col2) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 in (select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 in (select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
--TEST: 1 table, combination with any, some, all
select col1, col3, col5 from ntile_sq where col1 = any(select ntile(5) over(partition by col2 order by col2) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = any(select ntile(5) over(partition by col2 order by col2) b_num from ntile_sq order by col2) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = some(select ntile(5) over(partition by col3 order by col5) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = some(select ntile(5) over(partition by col3 order by col5) b_num from ntile_sq order by col3) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = all(select ntile(5) over(partition by col4 order by col1) b_num from ntile_sq) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = all(select ntile(5) over(partition by col4 order by col1) b_num from ntile_sq order by col4) order by 1, 2, 3; 
--TEST: 2 tables, combination with any, some, all
select col1, col3, col5 from ntile_sq where col1 = any(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = some(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 = all(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 > any(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 < some(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 < some(select ntile(5) over(partition by str order by id) b_num from t order by str) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 > all(select ntile(5) over(partition by str order by id) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq where col1 > all(select ntile(5) over(partition by str order by id) b_num from t order by str) order by 1, 2, 3; 
--TEST: combination with exists, use ntile functions in a correlated subquery
select col1, col3, col5 from ntile_sq c where exists (select ntile(5) over(order by id) b_num from t where t.id=c.col1) order by 1, 2, 3; 
select col1, col3, col5 from ntile_sq c where exists (select ntile(5) over(partition by str order by id) b_num from t where t.id=c.col1) order by 1, 2, 3; 




drop table t;
drop table ntile_sq;


