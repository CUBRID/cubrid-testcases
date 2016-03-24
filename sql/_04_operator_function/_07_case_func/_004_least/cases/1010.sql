--test least function with char and other type as its operands
select least('char', date'2/2/2002') from db_root;
select least('char', time'3:3:3 am') from db_root;
select least('char', timestamp'2/2/2001 2:2:2 am') from db_root;
select least('char', b'00101010') from db_root;
select least('char', 10) from db_root;
select least('char', 10.23) from db_root;
select least('char', n'nchar') from db_root;
select least('char', {1,2}) from db_root;
