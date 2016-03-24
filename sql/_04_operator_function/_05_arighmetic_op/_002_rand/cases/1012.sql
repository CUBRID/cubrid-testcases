--test rand function with types char, nchar 
select rand('char') from db_root;
select rand(n'nchar') from db_root order by 1;