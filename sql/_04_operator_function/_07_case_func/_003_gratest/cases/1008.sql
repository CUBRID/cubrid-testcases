--test greatest function with numeric and other type as its operands
select greatest(10.23, 'aaa') from db_root;
select greatest(10.23, n'aaa') from db_root;
select greatest(10.23, date'2/2/2002') from db_root;
select greatest(10.23, time'3:3:3 am') from db_root;
select greatest(10.23, timestamp'2/2/2001 2:2:2 am') from db_root;
select greatest(10.23, b'00101010') from db_root;
select greatest(10.23, {1,2}) from db_root order by 1;