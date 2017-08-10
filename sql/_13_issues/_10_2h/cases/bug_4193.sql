create table test1 (a int, b varchar(100));
insert into test1 values (1, '`abc'), (2, 'abcde'), (3,'`abdef'), 
			(4, 'ab%'), (5, '`ab%');
insert into test1 values (1, '\abc'), (2, 'abcde'), (3,'\abdef'),
			(4, 'ab%'), (5, '\ab%');

insert into test1 values (6, '/path/file_name1'), (7, '/path/file_name2');
insert into test1 values (8, 'a_b'), (9, 'a\b_c'), (10, 'a\b_c\');

select * from test1 where b like '\/path\/file\_name%' escape '\' order by 1;
select * from test1 where b like '`/path`/file`_name%' escape '`' order by 1;
select * from test1 where b like '^/path^/file^_name%' escape '^' order by 1;

select * from test1 where b like 'a\_b' escape '\' order by 1;
select * from test1 where b like 'a`_b' escape '`' order by 1;
select * from test1 where b like 'a^_b' escape '^' order by 1;

select * from test1 where b like 'a\\b\_c' escape '\' order by 1;
select * from test1 where b like 'a`\b`_c' escape '`' order by 1;
select * from test1 where b like 'a^\b^_c' escape '^' order by 1;

select * from test1 where b like 'a\\b\_c\\' escape '\' order by 1;
select * from test1 where b like 'a`\b`_c`\' escape '`' order by 1;
select * from test1 where b like 'a^\b^_c^\' escape '^' order by 1;

select * from test1 where b like 'a\\b\_c%' escape '\' order by 1;
select * from test1 where b like 'a`\b`_c%' escape '`' order by 1;
select * from test1 where b like 'a^\b^_c%' escape '^' order by 1;

select * from test1  where b like '\\ab%' escape '\' order by 1;
select * from test1  where b like '`\ab%' escape '`' order by 1;
select * from test1  where b like '^\ab%' escape '^' order by 1;

select * from test1  where b like '\`ab%' escape '\' order by 1;
select * from test1  where b like '``ab%' escape '`' order by 1;
select * from test1  where b like '^`ab%' escape '^' order by 1;

select * from test1  where b like '\\ab\%' escape '\' order by 1;
select * from test1  where b like '`\ab`%' escape '`' order by 1;
select * from test1  where b like '^\ab^%' escape '^' order by 1;

select * from test1  where b like '\`ab\%' escape '\' order by 1;
select * from test1  where b like '``ab`%' escape '`' order by 1;
select * from test1  where b like '^`ab^%' escape '^' order by 1;

select * from test1  where b like '\ab%' order by 1;
select * from test1  where b like '`ab%' order by 1;

select * from test1  where b like 'ab\%' escape '\' order by 1;
select * from test1  where b like 'ab`%' escape '`' order by 1;
select * from test1  where b like 'ab^%' escape '^' order by 1;


drop table test1;
