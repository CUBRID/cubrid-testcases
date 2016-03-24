--test power function using date and other types as its operand
select power(date'6/6/2006', 10) from db_root;
select power(date'6/6/2006', 10.12) from db_root;
select power(date'6/6/2006', time'8:8:8 am') from db_root;
select power(date'6/6/2006', date'6/6/2006') from db_root;
select power(date'6/6/2006', timestamp'5/5/2005 8:8:8 am') from db_root;
select power(date'6/6/2006', 'char') from db_root;
select power(date'6/6/2006', b'00001000') from db_root order by 1;