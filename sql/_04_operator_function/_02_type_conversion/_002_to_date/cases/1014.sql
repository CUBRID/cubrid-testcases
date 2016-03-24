--[er]test to_date using date and other types as its operand
select to_date(date'1/1/2001', 'YYYYMMDD') from db_root;
select to_date(date'1/1/2001', n'YYYYMMDD') from db_root;
select to_date(date'1/1/2001', 10) from db_root;
select to_date(date'1/1/2001', 10.1234) from db_root;
select to_date(date'1/1/2001', {1,2,3}) from db_root;
select to_date(date'1/1/2001', b'00100101010') from db_root;
select to_date(date'1/1/2001', date'1/1/2001') from db_root;
select to_date(date'1/1/2001', time'1:1:1 am') from db_root;
select to_date(date'1/1/2001', timestamp'1/1/2001 1:1:1 am') from db_root;

