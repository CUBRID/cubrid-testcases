--test mod function with timestamp type as its operand 
select mod(timestamp'8/8/2008 8:8:8 am', 10) from db_root;
select mod(10, timestamp'8/8/2008 8:8:8 am') from db_root;
select mod(timestamp'8/8/2008 8:8:8 am', timestamp'8/8/2008 8:8:8 am') from db_root;
select mod(timestamp'8/8/2008 8:8:8 am', 'abc') from db_root;
select mod(timestamp'8/8/2008 8:8:8 am', 33.33) from db_root;
