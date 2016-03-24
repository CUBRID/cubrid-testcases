--[er]test to_date using numeric and other types as its operand
select to_date(10.111, 'YYYYMMDD') from db_root;
select to_date(10.111, n'YYYYMMDD') from db_root;
select to_date(10.111, 10) from db_root;
select to_date(10.111, 10.1234) from db_root;
select to_date(10.111, {1,2,3}) from db_root;
select to_date(10.111, b'00100101010') from db_root;
select to_date(10.111, date'1/1/2001') from db_root;
select to_date(10.111, time'1:1:1 am') from db_root;
select to_date(10.111, timestamp'1/1/2001 1:1:1 am') from db_root;
