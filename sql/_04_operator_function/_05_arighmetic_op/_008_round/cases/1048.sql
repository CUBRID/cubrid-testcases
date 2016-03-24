--test round function using bit and other types as its operand
select round(b'000010000', 10) from db_root;
select round(b'000010000', 10.12) from db_root;
select round(b'000010000', time'8:8:8 am') from db_root;
select round(b'000010000', date'6/6/2006') from db_root;
select round(b'000010000', timestamp'5/5/2005 8:8:8 am') from db_root;
select round(b'000010000', 'char') from db_root;
select round(b'000010000', b'0001000') from db_root order by 1;