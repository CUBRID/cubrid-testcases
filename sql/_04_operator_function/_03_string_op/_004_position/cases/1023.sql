--test position function using int and other type as its operand
select position(b'0010100101' in 10) from db_root;
select position(b'0010100101' in 10.11) from db_root;
select position(b'0010100101' in 'char111') from db_root;
select position(b'0010100101' in n'nchar111') from db_root;
select position(b'0010100101' in date'1/1/2001') from db_root;
select position(b'0010100101' in b'0010100101') from db_root;
select position(b'0010100101' in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(b'0010100101' in {3,4,5}) from db_root;
select position(b'0010100101' in b'01001000') from db_root;
select position(b'0010100101' in ) from db_root order by 1;