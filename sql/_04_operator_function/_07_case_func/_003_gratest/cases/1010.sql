--test greatest function with char and other type as its operands
select greatest('char', date'2/2/2002') from db_root;
select greatest('char', time'3:3:3 am') from db_root;
select greatest('char', timestamp'2/2/2001 2:2:2 am') from db_root;
select greatest('char', b'00101010') from db_root;
select greatest('char', 10) from db_root;
select greatest('char', 10.23) from db_root;
select greatest('char', n'nchar') from db_root;
select greatest('char', {1,2}) from db_root;
