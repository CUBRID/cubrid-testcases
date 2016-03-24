--[er]test trunc function using char and other type as its operand 
select trunc('char', 1) from db_root;
select trunc('char', 'char') from db_root;
select trunc('char', date'8/8/2008') from db_root;
select trunc('char', time'8:8:8 am') from db_root;
select trunc('char', timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc('char', 3.22) from db_root;
select trunc('char', {1,2,3}) from db_root;
select trunc('char', b'000100') from db_root;
select trunc('char', n'nchar') from db_root order by 1;