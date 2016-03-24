--test mod function with time type as its operand 
select mod(time'8:8:8 am', 10) from db_root;
select mod(10, time'8:8:8 am') from db_root;
select mod(time'8:8:8 am', time'8:8:8 am') from db_root;
select mod(time'8:8:8 am', 'abc') from db_root;
select mod(time'8:8:8 am', 33.33) from db_root;
