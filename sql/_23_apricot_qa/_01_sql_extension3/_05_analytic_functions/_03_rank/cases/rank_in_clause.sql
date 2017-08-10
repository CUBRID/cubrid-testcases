--use analytic function in order by/group by/having clause


create table rank_in_clause(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into rank_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into rank_in_clause(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into rank_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into rank_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into rank_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: error, use analytic functions in group by clause
select col1, col2 from rank_in_clause group by rank() over(order by col1);
select col2, col3, rank() over() from rank_in_clause group by rank() over(partition by col2 order by col1);
select col1, col2, rank() over(order by col1) rank from rank_in_clause group by rank;
select col1, col2, col3 from rank_in_clause group by rank() over(partition by col1 order by col2);


--TEST: error, use analytic functions in having clause
select col3, col5 from rank_in_clause group by col3 having rank() over(partition by col3 order by col1) > 3;
select col4, rank() over(partition by col4 order by col1) rank from rank_in_clause group by col4 having rank() over(order by col1) > 3;


--TEST: use analytic functions in order by clause
select col1, rank() over(order by col1) from rank_in_clause order by rank() over(order by col1);
--TEST: use more than one analytic function in the same query, in the select list and in ORDER BY clause of a query
select col1, col2, rank() over(partition by col1 order by col2) rank from rank_in_clause group by rank ,col1;
select col1, col2, rank() over(order by col1), col4 from rank_in_clause order by rank() over(partition by col2 order by col1);
select max(col1), col2, rank() over(order by max(col1), col2), min(col3) from rank_in_clause group by col2 order by rank() over(partition by col2 order by max(col1));



delete from rank_in_clause;
drop table rank_in_clause;


