--use analytic function in order by/group by/having clause


create table c_in_clause(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into c_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into c_in_clause(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into c_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into c_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into c_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: error, use analytic functions in group by clause
select col1, col2 from c_in_clause group by count(col1) over();
select col2, col3, count(col2) over() from c_in_clause group by count(col3) over(partition by col2);
select col1, col2, count(col2) over(order by col1) cnt from c_in_clause group by cnt;
select col1, col2, col3 from c_in_clause group by count(*) over(partition by col1 order by col2);


--TEST: error, use analytic functions in having clause
select col3, count(col3) from c_in_clause group by col3 having count(col3) over(partition by col3) > 3;
select col4, count(col4) over(partition by col4) cnt from c_in_clause group by col4 having cnt > 3;


--TEST: use analytic functions in order by clause
select col1, count(col1) over(order by col1) from c_in_clause order by count(col1) over(order by col1) desc;
--TEST: use more than one analytic function in the same query, in the select list and in ORDER BY clause of a query
select col1, col2, count(col2) over(partition by col1 order by col2) cnt from c_in_clause group by cnt ,col1;
select col1, col2, count(col2) over(order by col1), col4 from c_in_clause order by count(distinct col3) over(partition by col2 order by col1);
select col1, col2, count(*) over(order by col1, col2), col3 from c_in_clause group by col2 order by count(distinct col2) over();



delete from c_in_clause;
drop table c_in_clause;


