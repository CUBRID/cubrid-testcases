--test position function using int and other type as its operand
select position(timestamp'2/2/2002 2:2:2 am' in 10) from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in 10.11) from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in 'char111') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in n'nchar111') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in date'1/1/2001') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in timestamp'2/2/2002 2:2:2 am') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in {3,4,5}) from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in b'01001000') from db_root;
select position(timestamp'2/2/2002 2:2:2 am' in ) from db_root order by 1;