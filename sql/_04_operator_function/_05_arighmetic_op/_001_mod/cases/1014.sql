--test mod function with bit type as its operand 
select mod(b'0000101110', 10) from db_root;
select mod(timestamp'8/8/2008 8:8:8 am', b'0000101110') from db_root;
select mod('aaa', b'0000101110') from db_root;
select mod(time'8:8:8 am', b'0000101110') from db_root;
select mod(date'8/8/2008', b'0000101110') from db_root;
