--[er]test trunc function using date and other type as its operand 
select trunc(date'8/8/2008', 1) from db_root;
select trunc(1,date'8/8/2008') from db_root;
select trunc(date'8/8/2008', date'8/8/2008') from db_root;
select trunc(date'8/8/2008', time'8:8:8 am') from db_root;
select trunc(date'8/8/2008', timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc(date'8/8/2008', 'char') from db_root;
select trunc(date'8/8/2008', n'nchar') from db_root;
select trunc(date'8/8/2008', b'001001000') from db_root;
select trunc(date'8/8/2008', {1,2,3}) from db_root order by 1;