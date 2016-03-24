--[er]test to_date using timestamp and other types as its operand
select to_date(timestamp'1/1/2001 1:1:1 am', 'YYYYMMDD') from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', n'YYYYMMDD') from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', 10) from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', 10.1234) from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', {1,2,3}) from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', b'00100101010') from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', date'1/1/2001') from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', time'1:1:1 am') from db_root;
select to_date(timestamp'1/1/2001 1:1:1 am', timestamp'1/1/2001 1:1:1 am') from db_root;
