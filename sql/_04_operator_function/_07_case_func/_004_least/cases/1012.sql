--test least function with set and other type as its operands
select least({1,2}, date'2/2/2002') from db_root;
select least({1,2}, time'3:3:3 am') from db_root;
select least({1,2}, timestamp'2/2/2001 2:2:2 am') from db_root;
select least({1,2}, 10) from db_root;
select least({1,2}, 10.23) from db_root;
select least({1,2}, n'nchar') from db_root;
select least({1,2}, 'char') from db_root;
select least({1,2}, b'01010100') from db_root;
