--test position function using decimal and other type as its operand
select position(88.52 in 10) from db_root;
select position(88.52 in 10.11) from db_root;
select position(88.52 in 'char111') from db_root;
select position(88.52 in n'nchar111') from db_root;
select position(88.52 in date'1/1/2001') from db_root;
select position(88.52 in time'2:2:2 am') from db_root;
select position(88.52 in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(88.52 in {3,4,5}) from db_root;
select position(88.52 in b'01001000') from db_root;
select position(88.52 in ) from db_root order by 1;