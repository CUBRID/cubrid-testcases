--test mod function with date type as its operand 
select mod(date'8/8/2008', 10) from db_root;
select mod(10, date'8/8/2008') from db_root;
select mod(date'8/8/2008', date'8/8/2008') from db_root;
select mod(date'8/8/2008', 'abc') from db_root;
select mod(date'8/8/2008', 33.33) from db_root;
