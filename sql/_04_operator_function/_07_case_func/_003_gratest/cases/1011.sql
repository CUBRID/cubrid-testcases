--test greatest function with bit and other type as its operands
select greatest(b'00101010', date'2/2/2002') from db_root;
select greatest(b'00101010', time'3:3:3 am') from db_root;
select greatest(b'00101010', timestamp'2/2/2001 2:2:2 am') from db_root;
select greatest(b'00101010', 10) from db_root;
select greatest(b'00101010', 10.23) from db_root;
select greatest(b'00101010', n'nchar') from db_root;
select greatest(b'00101010', 'char') from db_root;
select greatest(b'00101010', {1,2}) from db_root order by 1;