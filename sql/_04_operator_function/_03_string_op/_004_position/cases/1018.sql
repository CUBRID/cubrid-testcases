--test position function using int and other type as its operand
select position(86 in 10) from db_root;
select position(86 in 10.11) from db_root;
select position(86 in 'char111') from db_root;
select position(86 in n'nchar111') from db_root;
select position(86 in date'1/1/2001') from db_root;
select position(86 in time'2:2:2 am') from db_root;
select position(86 in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(86 in {3,4,5}) from db_root;
select position(86 in b'01001000') from db_root;
select position(86 in ) from db_root order by 1;