--test drand function with types char, nchar 
select drand('char') from db_root;
select drand(n'nchar') from db_root order by 1;