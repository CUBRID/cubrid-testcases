--test mod function with char type as its operand 
select mod('aaa', 10) from db_root;
select mod(10, 'aaa') from db_root;
select mod('aaa', timestamp'8/8/2008 8:8:8 am') from db_root;
select mod(time'8:8:8 am', 'abc') from db_root;
select mod(date'8/8/2008', 'aaa') from db_root;
