--[er]test to_time function with types char, nchar
select to_time('char') from db_root;
select to_time(n'nchar') from db_root order by 1;