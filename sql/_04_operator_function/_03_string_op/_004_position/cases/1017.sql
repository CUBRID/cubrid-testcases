--test position function using char, nchar and other type as its operand
select position('char' in 10) from db_root;
select position('char' in 10.11) from db_root;
select position('char' in n'nchar111') from db_root;
select position('char' in date'1/1/2001') from db_root;
select position('char' in time'2:2:2 am') from db_root;
select position('char' in timestamp'1/1/2001 2:2:2 am') from db_root;
select position('char' in {3,4,5}) from db_root;
select position('char' in b'01001000') from db_root;
select position('char' in ) from db_root;

select position(n'nchar' in 10) from db_root;
select position(n'nchar' in 10.11) from db_root;
select position(n'nchar' in 'char111') from db_root;
select position(n'nchar' in date'1/1/2001') from db_root;
select position(n'nchar' in time'2:2:2 am') from db_root;
select position(n'nchar' in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(n'nchar' in {3,4,5}) from db_root;
select position(n'nchar' in b'01001000') from db_root;
select position(n'nchar' in ) from db_root order by 1;