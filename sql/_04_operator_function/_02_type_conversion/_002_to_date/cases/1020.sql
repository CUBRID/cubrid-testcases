--[er]test to_date using numeric and other types as its operand
select to_date({1,2,3}, 'YYYYMMDD') from db_root;
select to_date({1,2,3}, n'YYYYMMDD') from db_root;
select to_date({1,2,3}, 10) from db_root;
select to_date({1,2,3}, 10.1234) from db_root;
select to_date({1,2,3}, {1,2,3}) from db_root;
select to_date({1,2,3}, b'00100101010') from db_root;
select to_date({1,2,3}, date'1/1/2001') from db_root;
select to_date({1,2,3}, time'1:1:1 am') from db_root;
select to_date({1,2,3}, timestamp'1/1/2001 1:1:1 am') from db_root;
