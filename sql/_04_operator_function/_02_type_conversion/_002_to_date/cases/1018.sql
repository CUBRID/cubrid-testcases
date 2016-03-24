--[er]test to_date using int and other types as its operand
select to_date(10, 'YYYYMMDD') from db_root;
select to_date(10, n'YYYYMMDD') from db_root;
select to_date(10, 10) from db_root;
select to_date(10, 10.1234) from db_root;
select to_date(10, {1,2,3}) from db_root;
select to_date(10, b'00100101010') from db_root;
select to_date(10, date'1/1/2001') from db_root;
select to_date(10, time'1:1:1 am') from db_root;
select to_date(10, timestamp'1/1/2001 1:1:1 am') from db_root;
