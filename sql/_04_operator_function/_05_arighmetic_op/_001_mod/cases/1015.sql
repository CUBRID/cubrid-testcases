--test mod function with set type as its operand 
select mod({1,2,3}, 10) from db_root;
select mod({1,2,3}, b'0000101110') from db_root;
select mod('aaa', {1,2,3}) from db_root;
select mod(time'8:8:8 am', {1,2,3}) from db_root;
select mod(date'8/8/2008', {1,2,3}) from db_root;
select mod(timestamp'8/8/2008 8:8:8 am', {1,2,3}) from db_root;
