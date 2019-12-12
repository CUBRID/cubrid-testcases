--use the function in a sub query 


create table wb_sq(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into wb_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into wb_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into wb_sq(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into wb_sq(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into wb_sq(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into wb_sq(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into wb_sq(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into wb_sq(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into wb_sq(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into wb_sq(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into wb_sq(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into wb_sq(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into wb_sq(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into wb_sq(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into wb_sq(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into wb_sq(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into wb_sq(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into wb_sq(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into wb_sq(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into wb_sq(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into wb_sq(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into wb_sq(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into wb_sq(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into wb_sq(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into wb_sq(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into wb_sq(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into wb_sq(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into wb_sq(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into wb_sq(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');



--TEST:  width_bucket function in a subquery as a select expression
select (select width_bucket(col2, 300, 800, 100) from wb_sq where col1=10) from wb_sq;
--TEST: 2 tables
create table t(id int, str char(20));
insert into t values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into t values(11, 'aaa'), (12, 'bbb'), (13, 'ccc'), (14, 'ddd'), (15, 'eee'), (16, 'fff');
--TEST: width_bucket function in a subquery as a select expression
select c.col1, c.col3, (select width_bucket(col4, '1990-01-01', '1996-12-31', 30) from t where c.col1=t.id) rn, c.col4, c.col5 from wb_sq c order by 1, 2, 3, 4, 5;



--TEST: Use width_bucket function in a subquery used as a table specification for the outer query
select b_num from (select width_bucket(col1, -10, 50, 10) b_num from wb_sq) order by 1;
select col1, col2, b_num, col3 from (select *, width_bucket(col1, 1, 30, 5) b_num from wb_sq) order by 1,2,3,4;
--TEST: Use width_bucket functions in a subquery used as a table specification for the outer query, use the return result in the outer query
select col1, col2, b_num, col3 from (select *, width_bucket(col2, 500, 506, 10) b_num from wb_sq) where b_num > 3 order by 1,2,3,4;


--TEST: use width_bucket functions in where clause
--TEST: combination with comparison operators

--TEST: combination with =
select col1, col2, col3, col4 from wb_sq where col1 = (select width_bucket(col4, '1990-10-10 12:00:00', '1996-10-10 12:00:00', 5) b_num from wb_sq order by col4 desc limit 1);
--TEST: combination with <
select col1, col2, col3, col4 from wb_sq where col1 < (select max(b_num) from (select width_bucket(col1, 1, 31, 6) b_num from wb_sq order by str));
--TEST: combination with >=, self-contained
select col1, col2, col3, col4 from wb_sq where col1 >= (select width_bucket(col2, 500, 510, 2) b_num from wb_sq where col1=15) order by 1,2,3,4;

--TEST: combination with in
select col1, col3, col5 from wb_sq where col1 in (select width_bucket(col4, '1990-10-10 12:00:00', '1996-10-10 12:00:00', 2) b_num from wb_sq) order by 1, 2, 3; 
--TEST: 1 table, combination with any, some, all
select col1, col3, col5 from wb_sq where col1 = any(select width_bucket(col1, 1, 50, 50) b_num from wb_sq) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 = some(select width_bucket(col2, 500, 566, 20) b_num from wb_sq order by col1) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 = all(select width_bucket(col4, '1990-10-10 12:00:00', '1996-10-10 12:00:00', 10) b_num from wb_sq order by col4) order by 1, 2, 3; 
--TEST: 2 tables, combination with any, some, all
select col1, col3, col5 from wb_sq where col1 = any(select width_bucket(id, 1, 30, 4) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 = some(select width_bucket(col2, 501, 508, 2) b_num from wb_sq) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 = all(select width_bucket(col4, '1990-10-10 12:00:00', '1996-10-10 12:00:00', 5) b_num from wb_sq) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 > any(select width_bucket(id, -1, 100, 7) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 < some(select width_bucket(col2, 1, 600, 20) b_num from wb_sq) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 < some(select width_bucket(col4, '1990-10-10 12:00:00', '1996-10-10 12:00:00', 8) b_num from wb_sq order by col4) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 > all(select width_bucket(id, 1, 30, 10) b_num from t) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq where col1 > all(select width_bucket(col2, 501, 508, 15) b_num from wb_sq order by col1) order by 1, 2, 3; 
--TEST: combination with exists, use width_bucket functions in a correlated subquery
select col1, col3, col5 from wb_sq c where exists (select width_bucket(id, 1, 50, 20) b_num from t where t.id=c.col1) order by 1, 2, 3; 
select col1, col3, col5 from wb_sq c where exists (select width_bucket(id, 1, 20, 20) b_num from t where t.id=c.col1) order by 1, 2, 3; 



drop table t;
drop table wb_sq;


