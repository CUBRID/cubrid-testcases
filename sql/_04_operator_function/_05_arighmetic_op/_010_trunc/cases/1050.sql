--[er]test trunc function using set and other type as its operand 
select trunc({1,2,3}, 1) from db_root;
select trunc({1,2,3}, 'char') from db_root;
select trunc({1,2,3}, date'8/8/2008') from db_root;
select trunc({1,2,3}, time'8:8:8 am') from db_root;
select trunc({1,2,3}, timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc({1,2,3}, 3.22) from db_root;
select trunc({1,2,3}, {1,2,3}) from db_root;
select trunc({1,2,3}, b'000100') from db_root;
select trunc({1,2,3}, n'nchar') from db_root order by 1;