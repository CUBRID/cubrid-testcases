--string functions using enum type as arguments


create table func(
	id bigint primary key auto_increment, 
	col1 enum('100', '123.45678', '999999999.999999999', '2e+30', '2e+39', '2e+309') default 2,
	col2 enum('cubrid', 'mysql', 'oracle', 'sqlite', 'mssql') default left('cubrid', 6),
	col3 enum('12:12:12', '10:11:12', '15:16:17 PM', '22:22:22', '25:25:25') default '10:11:12',
	col4 enum('2000-10-10', '1554-09-08', '12/11/1786', '01/01/2001', '1983-15-12') default '12/11/1786',
	col5 enum('1998-10-10 12:12:12', '12:12:12 10/10/1998', '2010-08-20 07:20:34', '1654-12:12 12:12:12') default 4,
	str varchar
);

insert into func values(default, 1, 1, 1, 1, 1, 'abc');
insert into func values(default, 2, 2, 2, 2, 2, 'bcd');
insert into func values(default, 3, 3, 3, 3, 3, 'cde');
insert into func values(default, 4, 4, 4, 4, 4, 'def');
insert into func default;


--TEST: string functions
select id, col2, bit_length(col2) from func order by 1;
select id ,col2, char_length(col2) from func order by 1;
select id ,col2, character_length(col2) from func order by 1;
select id ,col1, chr(col1) from func order by 1;
select id ,col2, col1, concat(col2, col1) from func order by 1;
select id ,col2, concat_ws(col1, col2, col3) from func order by 1;
select id ,col2, elt(2, col1, col2, col3, col4, col5) from func order by 1;
select id ,col2, field(col2, col1, col2, col3, col4, col5) from func order by 1;
select id ,col2, insert(col2, 2, 2, col1) from func order by 1;
select id ,col2, instr(col2, 'r') from func order by 1;
select id ,col2, lcase(col2) from func order by 1;
select id ,col2, lower(col2) from func order by 1;
select id ,col2, left(col2, col1) from func order by 1;
select id ,col2, length(col2) from func order by 1;
select id ,col2, lengthb(col2) from func order by 1;
select id ,col2, locate(right(col2, 2), col2) from func order by 1;
select id ,col2, lpad(col2, 10, '?') from func order by 1;
select id ,col2, ltrim(col2, 'c') from func order by 1;
select id ,col2, mid(col2, 2, 3) from func order by 1;
select id ,col2, octet_length(col2) from func order by 1;
select id ,col2, position('r' in col2) from func order by 1;
select id ,col2, repeat(col2, 2) from func order by 1;
select id ,col2, replace(col2, 'r', 'R') from func order by 1;
select id ,col2, reverse(col2) from func order by 1;
select id ,col2, right(col2, 3) from func order by 1;
select id ,col2, rpad(col2, 3, '#') from func order by 1;
select id ,col2, rtrim(col2, 'e') from func order by 1;
select id ,col2, strcmp(col2, col2) from func order by 1;
select id ,col2, strcmp(col2, col3) from func order by 1;
select id ,col2, substr(col2, 2, 4) from func order by 1;
select id ,col2, substring(col2, 1, 5) from func order by 1;
select id ,col2, substring_index(col2+'.'+'a'+'.'+'b', '.', 2) from func order by 1;
select id ,col2, translate(col2+'abcde', 'abcde', '12345') from func order by 1;
select id ,col2, trim('i' from 'aaaiii'+col2+'bbbiii') from func order by 1;
select id ,col2, ucase(col2) from func order by 1;
select id ,col2, upper(col2) from func order by 1;



drop table func;


