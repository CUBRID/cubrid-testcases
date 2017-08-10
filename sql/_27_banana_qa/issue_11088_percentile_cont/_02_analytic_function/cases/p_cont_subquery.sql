--use analytic function in a subquery

drop table if exists p_cont_subquery;
create table p_cont_subquery(
	col1 smallint auto_increment primary key,
	col2 bigint not null,
	col3 varchar default 'abc',
	col4 timestamp default CURRENT_TIMESTAMP,
	col5 bit(20)
);


insert into p_cont_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'0001');
insert into p_cont_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10 11:12:13', B'0010');
insert into p_cont_subquery(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11 11:12:13', B'0100');
insert into p_cont_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10 11:12:13', B'1000');
insert into p_cont_subquery(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10 11:12:13', B'0011');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10 11:12:13', B'0101');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10 11:12:13', B'1001');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10 11:12:13', B'0110');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10 11:12:13', B'1010');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10 11:12:13', B'1100');
insert into p_cont_subquery(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10 11:12:13', B'0111');
insert into p_cont_subquery(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into p_cont_subquery(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10 11:12:13', B'1111');
insert into p_cont_subquery(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10 11:12:13', B'1010');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10 11:12:13', B'0101');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'1110');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10 11:12:13', B'0111');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10 11:12:13', B'1101');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10 11:12:13', B'0011');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10 11:12:13', B'0001');
insert into p_cont_subquery(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10 11:12:13', B'1100');
insert into p_cont_subquery(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10 11:12:13', B'1011');
insert into p_cont_subquery(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10 11:12:13', null);
insert into p_cont_subquery(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10 11:12:13', B'0110');
insert into p_cont_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10 11:12:13', '');
insert into p_cont_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10 11:12:13', B'1111');
insert into p_cont_subquery(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10 11:12:13', B'0100');
insert into p_cont_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10 11:12:13', null);
insert into p_cont_subquery(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10 11:12:13', B'1111');



--TEST: analytic function in a subquery as a select expression
select (select percentile_cont(0.67) within group (order by col2 desc) over(partition by col3) from p_cont_subquery where col1=10) p_cont from p_cont_subquery;
--TEST: 2 tables
drop table if exists ttt;
create table ttt(id int, str char(20));
insert into ttt values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into ttt values(11, 'aaa'), (12, 'bbb'), (13, 'ccc'), (14, 'ddd'), (15, 'eee'), (16, 'fff');
--TEST: analytic function in a subquery as a select expression
select c.col1, c.col3, (select percentile_cont(0.11) within group (order by t.id) over(partition by t.str) p_cont from ttt t where c.col1=t.id) as p_cont, c.col4, c.col5 from p_cont_subquery c order by 1, 2, 3, 4, 5;
select c.col1, c.col3, (select percentile_cont(0.11) within group (order by c.col1) over(partition by t.str) from ttt t order by 1 limit 1) as p_cont, c.col4, c.col5 from p_cont_subquery c order by 1, 2, 3, 4, 5;



--TEST: Use analytic functions in a subquery used as a table specification for the outer query
select col1, col2, p_cont, col3 from (select *, percentile_cont(0.23) within group (order by col1) over(partition by col4) p_cont from p_cont_subquery) order by 3, 2, 1;
--TEST: Use analytic functions in a subquery used as a table specification for the outer query, use the return result in the outer query
select col1, col2, p_cont1, p_cont2, col3 from (select *, percentile_cont(0.54) within group (order by col4 desc) over(partition by col2) p_cont1, percentile_cont(0.83) within group (order by col1) over(partition by col2) p_cont2 from p_cont_subquery) where p_cont2 > 15;


--TEST: use analytic functions in where clause
--TEST: combination with comparison operators

--TEST: combination with =
select col1, col2, col3, col4 from p_cont_subquery ss where col1 = (select percentile_cont(0.4) within group (order by ss.col2) over(partition by str) p_cont from ttt order by str limit 1) order by 1;
--TEST: combination with <
select col1, col2, col3, col4 from p_cont_subquery where col1 < (select p_cont from (select percentile_cont(0.4) within group (order by id) over(partition by str) p_cont from ttt order by str) limit 1) order by 1;
--TEST: combination with >=, self-contained
select col1, col2, col3, col4 from p_cont_subquery where col1 >= (select percentile_cont(0.56) within group (order by col2) over(partition by col3) p_cont from p_cont_subquery where col1=15) order by 1;

--TEST: combination with in
select col1, col3, col5 from p_cont_subquery where col1 in (select percentile_cont(0.1) within group (order by id) over(partition by str) p_cont from ttt order by str) order by 1; 
--TEST: combination with any/some
select col1, col3, col5 from p_cont_subquery where col1 = any (select percentile_cont(0.1) within group (order by id) over(partition by str) p_cont from ttt) order by 1; 
select col1, col3, col5 from p_cont_subquery where col1 = some(select percentile_cont(0.2) within group (order by id) over(partition by str) p_cont from ttt) order by 1; 
--TEST: combination with
select col1, col3, col5 from p_cont_subquery where col1 = (select percentile_cont(0.3) within group (order by id) over(partition by str) p_cont from ttt order by id desc limit 1) order by 1; 
--TEST: combination with exists, use analytic functions in a correlated subquery
select col1, col3, col5 from p_cont_subquery c where exists (select percentile_cont(0.4) within group (order by id) over(partition by str) p_cont from ttt t where t.id=c.col1) order by 1, 2, 3; 




drop ttt;
drop table p_cont_subquery;


