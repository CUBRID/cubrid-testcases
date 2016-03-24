--[er]test to_date using bit and other types as its operand
select to_date(b'01010010', 'YYYYMMDD') from db_root;
select to_date(b'01010010', n'YYYYMMDD') from db_root;
select to_date(b'01010010', 10) from db_root;
select to_date(b'01010010', 10.1234) from db_root;
select to_date(b'01010010', {1,2,3}) from db_root;
select to_date(b'01010010', b'00100101010') from db_root;
select to_date(b'01010010', date'1/1/2001') from db_root;
select to_date(b'01010010', time'1:1:1 am') from db_root;
select to_date(b'01010010', timestamp'1/1/2001 1:1:1 am') from db_root;
