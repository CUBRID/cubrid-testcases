--test greatest function with nchar and other type as its operands
select greatest(n'nchar', 'aaa') from db_root;
select greatest(n'nchar', date'2/2/2002') from db_root;
select greatest(n'nchar', time'3:3:3 am') from db_root;
select greatest(n'nchar', timestamp'2/2/2001 2:2:2 am') from db_root;
select greatest(n'nchar', b'00101010') from db_root;
select greatest(n'nchar', 10) from db_root;
select greatest(n'nchar', 10.23) from db_root;
select greatest(n'nchar', {1,2}) from db_root;
