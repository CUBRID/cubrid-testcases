--use analytic function in order by/group by/having clause

drop table if exists p_cont_in_clause;
create table p_cont_in_clause(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 varchar(20)
);


insert into p_cont_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into p_cont_in_clause(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into p_cont_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into p_cont_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into p_cont_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: error, use analytic functions in group by clause
select col1, col2 from p_cont_in_clause group by percentile_cont(0.33) within group (order by col1) over();
select col2, col3, percentile_cont(0.1) within group (order by col2) over() from p_cont_in_clause group by percentile_cont(0.2) within group (order by col1) over(partition by col2);
select col1, col2, percentile_cont(0.3) within group (order by col2) over(partition by col3) p_cont from p_cont_in_clause group by p_cont;
select col1, col2, col3 from p_cont_in_clause group by percentile_cont(0.45) within group (order by col1) over(partition by col5);


--TEST: error, use analytic functions in having clause
select col3, percentile_cont(1.2) within group (order by col2) over() from p_cont_in_clause group by col3 having percentile_cont(0.5) within group (order by col1) over(partition by col3) > 3;
select col4, percentile_cont(0.6) within group (order by col4) over(partition by col2) p_cont from p_cont_in_clause group by col4 having p_cont > 3;


--TEST: use analytic functions in order by clause
select col5, percentile_cont(0.66) within group (order by col4) over(partition by col5) from p_cont_in_clause order by col5, percentile_cont(0.6) within group (order by col2) over();
--TEST: use more than one analytic function in the same query, in the select list and in ORDER BY clause of a query
select col1, col2, percentile_cont(0.72) within group (order by col2) over(partition by col5) p_cont from p_cont_in_clause group by p_cont, col1;
select col2, percentile_cont(0.81) within group (order by col1) over(partition by col2) from p_cont_in_clause order by 1, percentile_cont(0.81) within group (order by col4) over(partition by col2);

--BUG: CUBRIDSUS-16039 (resolved)
select col4, col5, col2, percentile_cont(0.85) within group (order by col4) over(partition by col5, col2) p_cont, col3 from p_cont_in_clause group by col4, col5, col2 order by percentile_cont(1) within group (order by col2) over(), 1, 2, 3, 5;


drop table p_cont_in_clause;


