--numeric functions using enum type as arguments


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


--TEST: numeric functions
select id, col1, substr(to_char(abs(col1)), 1, 14) from func order by 1;
select id, col1, substr(to_char(acos(col1)), 1,14) from func where col1=1 order by 1;
select id, col1, substr(to_char(asin(col1)), 1,14) from func order by 1;
select id, col1, substr(to_char(atan(col1)), 1,14) from func order by 1;
select id, col1, substr(to_char(atan2(col1, -1)), 1,14) from func order by 1;
select id, col1, substr(to_char(ceil(col1)), 1,14) from func order by 1;
select id, col1, substr(to_char(cos(col1)),1,14) from func order by 1;
select id, col1, substr(to_char(cot(col1)), 1, 14) from func order by 1;
select id, col1, substr(to_char(degrees(col1)),1,14) from func order by 1;
select id, col1, substr(to_char(exp(col1)),1,14) from func order by 1;
select id, col1, floor(col1) from func order by 1;
select id, col1, format(col1, 3) from func order by 1;
select id, col1, greatest(col1, col2, col3) from func order by 1;
select id, col1, least(col1, num) from func order by 1;
select id, col1, substr(to_char(ln(col1)),1,14) from func order by 1;
select id, col1, substr(to_char(log2(col1)),1,14) from func order by 1;
select id, col1, substr(to_char(log10(col1)),1,14) from func order by 1;
select id, col1, mod(col1, num) from func order by 1;
select id, col1, pow(col1, num) from func order by 1;
select id, col1, power(col1, col4) from func order by 1;
select id, col1, substr(to_char(radians(col1)),1,14) from func order by 1;
select id, col1, round(col1) from func order by 1;
select id, col1, sign(col1) from func order by 1;
select id, col1, substr(to_char(sqrt(col1)),1,14) from func order by 1;
select id, col1, substr(to_char(tan(col1)),1,14) from func order by 1;
select id, col1, trunc(col1, 2) from func order by 1;
select id, col1, truncate(col1, 2) from func order by 1;



drop table func;

