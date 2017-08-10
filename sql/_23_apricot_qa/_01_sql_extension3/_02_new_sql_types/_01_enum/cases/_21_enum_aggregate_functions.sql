--aggregate functions using enum type as arguments


create table func(
	id bigint unique auto_increment, 
	col1 enum('100', '123.45678', '999999999.999999999', '2e+30', '2e+39', '2e+309') default 2,
	col2 enum('cubrid', 'mysql', 'oracle', 'sqlite', 'mssql') default left('cubrid', 6),
	col3 enum('12:12:12', '10:11:12', '15:16:17 PM', '22:22:22', '25:25:25') default '10:11:12',
	col4 enum('2000-10-10', '1554-09-08', '12/11/1786', '01/01/2001', '1983-15-12') default '12/11/1786',
	col5 enum('1998-10-10 12:12:12', '12:12:12 10/10/1998', '2010-08-20 07:20:34', '1654-12:12 12:12:12') default 4,
	num int
);

insert into func values(default, 1, 1, 1, 1, 1, 5);
insert into func values(default, 2, 2, 2, 2, 2, 4);
insert into func values(default, 3, 3, 3, 3, 3, 3);
insert into func values(default, 4, 4, 4, 4, 4, 2);
insert into func default;


--TEST: aggregate functions
select avg(col1) from func order by 1;
select col1, avg(col1) over(order by col1) from func order by 1;
select count(col5) from func order by 1;
select col5, count(col5) over(partition by col3 order by col4) from func order by 1;
select group_concat(col2 order by col2) from func order by 1;
select max(cast(col1 as double)) from func order by 1;
select min(col1) from func order by 1;
select stddev(col1) from func order by 1;
select stddev_pop(col1) from func order by 1;
select stddev_samp(col1) from func order by 1;
select sum(col1) from func order by 1;
select var_pop(col1) from func order by 1;
select var_samp(col1) from func order by 1;
select variance(col1) from func order by 1;



drop table func;


