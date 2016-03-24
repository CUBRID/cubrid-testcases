--test least function with nchar and other type as its operands
select least(n'nchar', 'aaa') from db_root;
select least(n'nchar', date'2/2/2002') from db_root;
select least(n'nchar', time'3:3:3 am') from db_root;
select least(n'nchar', timestamp'2/2/2001 2:2:2 am') from db_root;
select least(n'nchar', b'00101010') from db_root;
select least(n'nchar', 10) from db_root;
select least(n'nchar', 10.23) from db_root;
select least(n'nchar', {1,2}) from db_root;
