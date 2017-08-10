--use analytic function in order by/group by/having clause


create table var_samp_in_clause(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob,
	col6 varchar
);


insert into var_samp_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'aello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-11-10', 'bello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(500, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', 'dello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1990-10-10', 'iello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'cubrid', '1990-10-10', 'jello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(501, 'mysql', '1991-11-10', 'kello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(502, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'qello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-11-10', 'rello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'oracle', '1993-10-10', 'sello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(503, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(504, 'mysql', '1990-10-10', null);
insert into var_samp_in_clause(col2, col3, col4, col5) values(504, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1991-10-10', '');
insert into var_samp_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(505, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into var_samp_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into var_samp_in_clause(col2, col3, col4, col5) values(505, 'cubrid', '1990-10-10', 'zello@domainname.com');



--TEST: error, use analytic functions in group by clause
select col1, col2 from var_samp_in_clause group by var_samp(col1) over();
select col2, col3, var_samp(col2) over() from var_samp_in_clause group by var_samp(col1) over(partition by col2);
select col1, col2, var_samp(col2) over(order by col1) var_samp from var_samp_in_clause group by var_samp;
select col1, col2, col3 from var_samp_in_clause group by var_samp(unique col1) over(partition by col1 order by col2);


--TEST: error, use analytic functions in having clause
select col3, var_samp(col2) from var_samp_in_clause group by col3 having var_samp(col1) over(partition by col3) > 3;
select col4, var_samp(distinct col2) over(partition by col4) var_samp from var_samp_in_clause group by col4 having var_samp > 3;


--TEST: use analytic functions in order by clause
select col1, var_samp(col1) over(order by col1) from var_samp_in_clause order by var_samp(col2) over(order by col1);
--TEST: use more than one analytic function in the same query, in the select list and in ORDER BY clause of a query
select col1, col2, var_samp(col2) over(partition by col1 order by col2) var_samp from var_samp_in_clause group by var_samp ,col1;
select col1, col2, var_samp(col2) over(order by col1), col4 from var_samp_in_clause order by var_samp(distinct col1) over(partition by col2 order by col1);
select 1 from (select col1, col2, var_samp(col1) over(order by col1, col2), col3 from var_samp_in_clause group by col2 order by var_samp(distinct col2) over());



delete from var_samp_in_clause;
drop table var_samp_in_clause;


