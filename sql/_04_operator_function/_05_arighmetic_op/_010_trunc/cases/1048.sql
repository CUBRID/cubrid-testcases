--[er]test trunc function using nchar and other type as its operand 
select trunc(n'nchar', 1) from db_root;
select trunc(n'nchar', 'char') from db_root;
select trunc(n'nchar', date'8/8/2008') from db_root;
select trunc(n'nchar', time'8:8:8 am') from db_root;
select trunc(n'nchar', timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc(n'nchar', 3.22) from db_root;
select trunc(n'nchar', {1,2,3}) from db_root;
select trunc(n'nchar', b'000100') from db_root;
select trunc(n'nchar', n'nchar') from db_root order by 1;