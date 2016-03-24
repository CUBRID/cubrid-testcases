--[er]test trunc function using timestamp and other type as its operand 
select trunc(timestamp'8/8/2008 8:8:8 am', 1) from db_root;
select trunc(1,timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', timestamp'8/8/2008 8:8:8 am') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', date'8/8/2008') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', time'8:8:8 am') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', 10.222) from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', n'nchar') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', 'char') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', b'00010010') from db_root;
select trunc(timestamp'8/8/2008 8:8:8 am', {1,2,3}) from db_root order by 1;