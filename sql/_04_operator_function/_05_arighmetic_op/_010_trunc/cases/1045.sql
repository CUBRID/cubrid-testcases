--[er]test trunc function using time and other type as its operand 
select trunc(time'8:8:8 am', 1) from db_root;
select trunc(1,time'8:8:8 am') from db_root;
select trunc(time'8:8:8 am', time'8:8:8 am') from db_root;
select trunc(time'8:8:8 am', 'char') from db_root;
select trunc(time'8:8:8 am', n'nchar') from db_root;
select trunc(time'8:8:8 am', date'8/8/2008') from db_root;
select trunc(time'8:8:8 am', timestamp'7/7/2007 7:7:7 am') from db_root;
select trunc(time'8:8:8 am', b'000100010') from db_root;
select trunc(time'8:8:8 am', {1,2,3}) from db_root order by 1;