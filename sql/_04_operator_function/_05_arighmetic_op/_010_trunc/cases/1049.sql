--[er]test trunc function using bit and other type as its operand 
select trunc(b'0010010010', 1) from db_root;
select trunc(b'0010010010', 'char') from db_root;
select trunc(b'0010010010', date'8/8/2008') from db_root;
select trunc(b'0010010010', time'8:8:8 am') from db_root;
select trunc(b'0010010010', timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc(b'0010010010', 3.22) from db_root;
select trunc(b'0010010010', {1,2,3}) from db_root;
select trunc(b'0010010010', b'000100') from db_root;
select trunc(b'0010010010', n'nchar') from db_root order by 1;