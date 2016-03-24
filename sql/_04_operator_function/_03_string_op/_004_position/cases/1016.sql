--test position function using null and other type as its operand
select position(null in 10) from db_root;
select position(null in 10.11) from db_root;
select position(null in 'char111') from db_root;
select position(null in n'nchar111') from db_root;
select position(null in date'1/1/2001') from db_root;
select position(null in time'2:2:2 am') from db_root;
select position(null in timestamp'1/1/2001 2:2:2 am') from db_root;
select position(null in {3,4,5}) from db_root;
select position(null in b'01001000') from db_root;
select position(null in null) from db_root;

select position(10 in null) from db_root;
select position(10.11 in null) from db_root;
select position('char111' in null) from db_root;
select position(n'nchar111' in null) from db_root;
select position(date'1/1/2001' in null) from db_root;
select position(time'2:2:2 am' in null) from db_root;
select position(timestamp'1/1/2001 2:2:2 am' in null) from db_root;
select position({3,4,5} in null) from db_root;
select position(b'01001000' in null) from db_root;


